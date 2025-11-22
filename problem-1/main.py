from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
from tabulate import tabulate
import time

url = "https://www.olx.in/items/q-car-cover?isSearchCall=true"

options = webdriver.ChromeOptions()
options.add_argument('--disable-blink-features=AutomationControlled')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--start-maximized')

try:
    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=options)
    
    driver.get(url)
    
    print("Waiting for ads to load...")
    time.sleep(5)
    
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight/2);")
    time.sleep(2)
    
    try:
        WebDriverWait(driver, 15).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "li[data-aut-id='itemBox']"))
        )
    except:
        pass
    
    listings = driver.find_elements(By.CSS_SELECTOR, "li[data-aut-id='itemBox']")
    
    if not listings:
        listings = driver.find_elements(By.CSS_SELECTOR, "li")
    
    ads = []
    
    for listing in listings:
        try:
            title_elem = listing.find_elements(By.CSS_SELECTOR, "span[data-aut-id='itemTitle']")
            if not title_elem:
                continue
            title = title_elem[0].text
            
            try:
                price = listing.find_element(By.CSS_SELECTOR, "span[data-aut-id='itemPrice']").text
            except:
                price = "N/A"
            
            try:
                location = listing.find_element(By.CSS_SELECTOR, "span[data-aut-id='item-location']").text
            except:
                location = "N/A"
            
            if title and title.strip():
                ads.append([title, price, location])
        
        except Exception as e:
            continue
    
    driver.quit()
    
    if ads:
        headers = ["Title", "Price", "Location"]
        print(tabulate(ads, headers=headers, tablefmt="grid"))
        print(f"\nTotal Ads Extracted: {len(ads)}")

except Exception as e:
    print(f"Error: {e}")
    
    try:
        driver.quit()
    except:
        pass