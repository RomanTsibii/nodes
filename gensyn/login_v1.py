from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from imapclient import IMAPClient
import pyzmail
import time
import re
from datetime import datetime, timezone, timedelta
import os
import getpass
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service
import threading

print("Очікую 15 секунд перед запуском порта...")
time.sleep(15)
LOGIN_URL = "http://localhost:3000"
# EMAIL = "romanot70@gmail.com"
# EMAIL_PASSWORD = "ptit vfcy uzqa hhtz"
# IMAP_SERVER = "imap.gmail.com"
# IMAP_PORT = 993
# IMAP_FOLDER = "INBOX"
CODE_WAIT_TIMEOUT = 180  # секунд (3 хвилини)
FUTURE_ALLOWANCE_SECONDS = 14400  # 4 години запасу на "майбутнє"

# Шукаємо лише листи, які прийшли після натискання Continue (по timestamp)
def get_new_verification_code_after_continue_by_time(ts_after_continue, max_age_seconds=120):
    with IMAPClient(IMAP_SERVER, port=IMAP_PORT, ssl=True) as client:
        client.login(EMAIL, EMAIL_PASSWORD)
        client.select_folder(IMAP_FOLDER)
        code = None
        start_time = time.time()
        tried_relaxed = False
        while time.time() - start_time < CODE_WAIT_TIMEOUT:
            messages = client.search(['ALL'])
            now = datetime.now(timezone.utc)
            found_valid = False
            for uid in reversed(messages):  # від найновіших до старих
                envelope = client.fetch([uid], ['ENVELOPE'])[uid][b'ENVELOPE']
                msg_date = envelope.date.replace(tzinfo=timezone.utc)
                age = (now - msg_date).total_seconds()
                future_delta = (msg_date - now).total_seconds()
                after_continue_delta = msg_date.timestamp() - ts_after_continue
                # Діагностичний лог
                print(f"UID: {uid}, Тема: {envelope.subject.decode() if envelope.subject else ''}, Дата: {msg_date}, Вік (сек): {age}, ΔпісляContinue={after_continue_delta}, Δмайбутнє={future_delta}")
                # Ігноруємо листи, які занадто далеко у майбутньому (більше FUTURE_ALLOWANCE_SECONDS)
                if future_delta > FUTURE_ALLOWANCE_SECONDS:
                    continue
                # Основний фільтр: після натискання Continue
                if (msg_date.timestamp() > ts_after_continue and age <= max_age_seconds) or (tried_relaxed and age <= 600):
                    found_valid = True
                    raw_message = client.fetch([uid], ['BODY[]'])[uid][b'BODY[]']
                    message = pyzmail.PyzMessage.factory(raw_message)
                    subject = message.get_subject()
                    if ("login code" in subject.lower() and "gensyn" in subject.lower()) or ("code" in subject.lower()):
                        text = None
                        if message.text_part:
                            text = message.text_part.get_payload().decode(message.text_part.charset)
                        elif message.html_part:
                            text = message.html_part.get_payload().decode(message.html_part.charset)
                        if text:
                            m = re.search(r'\b(\d{6})\b', text)
                            if m:
                                code = m.group(1)
                                print(f"Код знайдено, вводимо у форму! Код: {code}")
                                return code
            if not found_valid:
                print("[INFO] Немає валідних листів після натискання Continue (або всі з майбутнім часом)")
            # Якщо не знайдено коду за 60 секунд, пробуємо розширити фільтр (останні 10 хвилин)
            if not tried_relaxed and time.time() - start_time > 60:
                print("[INFO] Розширюємо фільтр: шукаємо код у листах за останні 10 хвилин!")
                tried_relaxed = True
            time.sleep(1)  # Зменшено з 5 до 1 секунди
        print("Не знайдено нових листів із кодом після натискання Continue!")
        return None

def print_latest_email_info():
    print("=== Інформація про найновіший лист у INBOX ===")
    with IMAPClient(IMAP_SERVER, port=IMAP_PORT, ssl=True) as client:
        client.login(EMAIL, EMAIL_PASSWORD)
        client.select_folder(IMAP_FOLDER)
        messages = client.search(['ALL'])
        if not messages:
            print("[WARN] INBOX порожній!")
            return
        latest_uid = messages[-1]
        envelope = client.fetch([latest_uid], ['ENVELOPE'])[latest_uid][b'ENVELOPE']
        msg_date = envelope.date.replace(tzinfo=timezone.utc)
        subject = envelope.subject.decode() if envelope.subject else ''
        print(f"UID: {latest_uid}")
        print(f"Тема: {subject}")
        print(f"Дата (з IMAP, UTC): {msg_date}")
        print(f"Дата (timestamp): {msg_date.timestamp()}")
        print("=============================================")

def get_latest_code_from_subject():
    with IMAPClient(IMAP_SERVER, port=IMAP_PORT, ssl=True) as client:
        client.login(EMAIL, EMAIL_PASSWORD)
        client.select_folder(IMAP_FOLDER)
        messages = client.search(['ALL'])
        if not messages:
            print("[WARN] INBOX порожній!")
            return None
        latest_uid = messages[-1]
        envelope = client.fetch([latest_uid], ['ENVELOPE'])[latest_uid][b'ENVELOPE']
        subject = envelope.subject.decode() if envelope.subject else ''
        # Шукаємо 6 цифр на початку теми
        m = re.match(r'^(\d{6})', subject.strip())
        if m:
            return m.group(1)
        else:
            print(f"[WARN] Не знайдено коду у темі: {subject}")
            return None

def load_email_env():
    env_path = '.env.email'
    config = {}
    if os.path.exists(env_path):
        with open(env_path, 'r') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#') or '=' not in line:
                    continue
                k, v = line.split('=', 1)
                config[k.strip()] = v.strip()
        print(f"[INFO] Завантажено налаштування з {env_path}")
    else:
        print(f"[INFO] Файл {env_path} не знайдено. Введіть дані вручну (Enter — стандартне для Gmail):")
        config['EMAIL'] = input('Email: ').strip()
        config['EMAIL_PASSWORD'] = getpass.getpass('Пароль від пошти (App Password для Gmail): ').strip()
        config['IMAP_SERVER'] = input('IMAP сервер [imap.gmail.com]: ').strip() or 'imap.gmail.com'
        port = input('IMAP порт [993]: ').strip()
        config['IMAP_PORT'] = int(port) if port else 993
        config['IMAP_FOLDER'] = input('IMAP папка [INBOX]: ').strip() or 'INBOX'
        # Зберігаємо у .env.email
        with open(env_path, 'w') as f:
            f.write(f"EMAIL={config['EMAIL']}\n")
            f.write(f"EMAIL_PASSWORD={config['EMAIL_PASSWORD']}\n")
            f.write(f"IMAP_SERVER={config['IMAP_SERVER']}\n")
            f.write(f"IMAP_PORT={config['IMAP_PORT']}\n")
            f.write(f"IMAP_FOLDER={config['IMAP_FOLDER']}\n")
        print(f"[INFO] Дані збережено у {env_path}")
    return config

# --- Завантажуємо налаштування ---
config = load_email_env()
EMAIL = config.get('EMAIL', '')
EMAIL_PASSWORD = config.get('EMAIL_PASSWORD', '')
IMAP_SERVER = config.get('IMAP_SERVER', 'imap.gmail.com')
IMAP_PORT = int(config.get('IMAP_PORT', 993))
IMAP_FOLDER = config.get('IMAP_FOLDER', 'INBOX')

options = webdriver.ChromeOptions()
options.add_argument("--headless")
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")

# --- НЕ додаємо user-data-dir для headless серверів ---

service = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=service, options=options)

driver.get(LOGIN_URL)

wait = WebDriverWait(driver, 30)

# Крок 1: Чекаємо кнопку Login і натискаємо
login_button = wait.until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, "button.btn.btn-primary"))
)
print("Кнопка Login знайдена!")
login_button.click()
print("Кнопка Login натиснута!")

# Крок 2: Чекаємо інпут для email і вписуємо адресу
email_input = wait.until(
    EC.visibility_of_element_located((By.CSS_SELECTOR, "input[type='email'][name='email']"))
)
print("Інпут для email знайдено!")
email_input.clear()
email_input.send_keys(EMAIL)
print("Email вписано!")

# Крок 3: Чекаємо кнопку Continue
continue_button = wait.until(
    EC.element_to_be_clickable((By.CSS_SELECTOR, "button.akui-btn.akui-btn-primary[type='submit']"))
)
print("Кнопка Continue знайдена!")

# --- Перед натисканням Continue зберігаємо поточний timestamp ---
ts_before_continue = time.time()

continue_button.click()
print("Кнопка Continue натиснута!")

print("Очікуємо 30 секунд, щоб лист з кодом встиг прийти...")
time.sleep(30)
code = get_latest_code_from_subject()
if code:
    print(f"Код з теми листа: {code}")
    otp_inputs = wait.until(
        EC.presence_of_all_elements_located((By.CSS_SELECTOR, "input[aria-label^='One time password input for the ']"))
    )
    if len(otp_inputs) >= 6:
        for i, digit in enumerate(code):
            otp_inputs[i].clear()
            otp_inputs[i].send_keys(digit)
        print("Код вписано у всі поля!")
    else:
        print("Не знайдено всі 6 input-ів для коду!")
else:
    print("Не вдалося знайти код у темі найновішого листа.")

# --- Замість time.sleep(60) і driver.quit() ---
def delayed_quit(driver, delay=60):
    time.sleep(delay)
    driver.quit()

threading.Thread(target=delayed_quit, args=(driver, 60), daemon=True).start()
# Основний код одразу завершується, браузер закриється через 60 секунд у фоні
