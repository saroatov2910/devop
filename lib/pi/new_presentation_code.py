import cv2
from pyzbar.pyzbar import decode
import os
import time
from picamera2 import Picamera2
import io
import numpy as np
from datetime import datetime
import requests
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Firebase setup
cred = credentials.Certificate("/home/pi/code/script/serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

EAN_API_KEY = "1B58A79568C00E49"

def enhance_image_for_barcode(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    blurred = cv2.medianBlur(gray, 3)
    thresh = cv2.adaptiveThreshold(
        blurred, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 11, 2
    )
    return thresh

def lookup_product_off(barcode):
    """Look up product using Open Food Facts"""
    url = f"https://world.openfoodfacts.org/api/v0/product/{barcode}.json"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            if data["status"] == 1:
                product = data["product"]
                name = product.get("product_name", "Unknown product")
                nutrition = product.get("nutriments", {})
                return name, nutrition
    except Exception as e:
        print(f"Open Food Facts error: {e}")
    return None, None

def lookup_product_eandata(barcode):
    """Look up product using EANData (requires API key)"""
    url = f"https://eandata.com/feed/?v=3&keycode={EAN_API_KEY}&mode=json&find={barcode}"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            if "product" in data and "attributes" in data["product"]:
                attrs = data["product"]["attributes"]
                name = attrs.get("product", "")
                brand = attrs.get("brand", "")
                full_name = f"{brand} {name}".strip()
                return full_name if full_name else None, {}
    except Exception as e:
        print(f"EANData API error: {e}")
    return None, None

def get_next_product_id():
    """Fetch the max product_id in My_Fridge and increment by 1."""
    docs = db.collection("My_Fridge").order_by("product_id", direction=firestore.Query.DESCENDING).limit(1).stream()
    max_id = -1
    for doc in docs:
        data = doc.to_dict()
        if "product_id" in data:
            max_id = max(max_id, data["product_id"])
    return max_id + 1

def add_or_update_product(barcode, name, nutrition):
    """Add new product or update existing quantity and timestamp in My_Fridge."""
    coll = db.collection("My_Fridge")

    # Query by barcode to see if product already exists
    docs = coll.where("product_barcode", "==", barcode).stream()

    existing_doc = None
    for doc in docs:
        existing_doc = doc
        break

    now_str = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    if existing_doc:
        # Product exists: increment quantity and update timestamp
        data = existing_doc.to_dict()
        new_quantity = data.get("quantity", 1) + 1
        existing_doc.reference.update({
            "quantity": new_quantity,
            "scanned_timestamp": now_str,
        })
        print(f"📦 Updated product '{data['product_name']}' quantity to {new_quantity}")
    else:
        # New product: get next product_id and add document
        new_id = get_next_product_id()
        product_data = {
            "product_id": new_id,
            "product_name": name,
            "product_barcode": barcode,
            "expiration_date": "",  # user can update later
            "product_status": "in_stock",
            "nutritional_info": nutrition,
            "quantity": 1,
            "scanned_timestamp": now_str,
        }
        coll.document(str(new_id)).set(product_data)
        print(f"✅ Added new product '{name}' with product_id {new_id}")

def continuous_barcode_scanner():
    picam2 = Picamera2()
    config = picam2.create_preview_configuration(main={"size": (1920, 1080)})
    picam2.configure(config)
    picam2.start()
    time.sleep(2)  # warm-up

    print("🔎 Starting continuous barcode scan. Press 'q' to quit.")

    try:
        while True:
            frame = picam2.capture_array()

            # Raw barcode detection
            raw_barcodes = decode(frame)

            # Enhanced image detection
            enhanced_img = enhance_image_for_barcode(frame)
            enhanced_barcodes = decode(enhanced_img)

            all_barcodes = raw_barcodes + enhanced_barcodes

            if all_barcodes:
                found = set()
                for barcode in all_barcodes:
                    barcode_data = barcode.data.decode("utf-8")
                    if barcode_data in found:
                        continue
                    found.add(barcode_data)
                    barcode_type = barcode.type

                    # Draw rectangle around barcode
                    if barcode.rect:
                        x, y, w, h = barcode.rect
                        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
                        cv2.putText(frame, f"{barcode_type}: {barcode_data}", (x, y - 10),
                                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)

                    print(f"✅ Found {barcode_type} barcode: {barcode_data}")

                    # Upload barcode info (optional: you can skip if you don't want a separate barcode collection)
                    db.collection("barcodes").document(barcode_data).set({
                        "type": barcode_type,
                        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                    })

                    # Product lookup
                    name, nutrition = lookup_product_off(barcode_data)
                    if not name:
                        print("🔁 Trying EANData as backup...")
                        name, nutrition = lookup_product_eandata(barcode_data)
                    if not name:
                        print("⚠️ Product not found in databases. Using default name.")
                        name = "no_name_product"
                        nutrition = {}

                    # Add or update product in Firestore
                    add_or_update_product(barcode_data, name, nutrition)

            cv2.imshow("Barcode Scanner", frame)
            key = cv2.waitKey(1) & 0xFF
            if key == ord('q'):
                print("❌ Quitting...")
                break

    except Exception as e:
        print(f"🚨 Error: {e}")

    finally:
        picam2.close()
        cv2.destroyAllWindows()

if __name__ == "__main__":
    continuous_barcode_scanner()