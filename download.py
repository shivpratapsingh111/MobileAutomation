import argparse
import requests
from bs4 import BeautifulSoup
import re
import json
import random
from urllib.parse import urlparse

USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; WOW64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.5748.222 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5786.212 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.5765.224 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36"
]

def get_random_user_agent():
    return random.choice(USER_AGENTS)

def get_apk_url(package_name):
    url0 = f"https://www.apkmonk.com/app/{package_name}/"
    headers = {'User-Agent': get_random_user_agent()}
    response = requests.get(url0, headers=headers)
    if response.status_code == 403:
        print(f"Firewall is blocking, Download APK from here: {url0}")
        return None
    soup = BeautifulSoup(response.content, 'html.parser')
    apk_link = soup.find('a', class_='waves-effect waves-light btn-large')
    if apk_link is None:
        print("Not Found on apkmonk.com \n Moving onto another target.")
        return None
    apk_href = apk_link.get('href')
    if not apk_href:
        print("Not Found on apkmonk.com \n Moving onto another target.")
        return None
    parsed_url = urlparse(apk_href)
    path_parts = parsed_url.path.split('/')
    key = path_parts[-1] if path_parts[-1] else path_parts[-2]
    url2 = f"https://www.apkmonk.com/down_file/?pkg={package_name}&key={key}"
    return url2

def download_apk(package_name, url):
    headers = {'User-Agent': get_random_user_agent()}
    response = requests.get(url, headers=headers)
    try:
        data = response.json()
        apk_url = data['url']
        response = requests.get(apk_url, stream=True, headers=headers)
        with open(f'{package_name}_apkMonk.apk', 'wb') as f:
            for chunk in response.iter_content(chunk_size=4096):
                f.write(chunk)
            print(f"Downloaded: {package_name}_apkMonk.apk")
    except json.decoder.JSONDecodeError:
        print("Error: Invalid JSON response or empty content.")

def main():
    parser = argparse.ArgumentParser(description='APK Downloader')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-f', metavar='FILE', help='Read package names from a file')
    group.add_argument('-p', metavar='PACKAGE', help='Provide a single package name')
    args = parser.parse_args()

    if args.f:
        with open(args.f, 'r') as file:
            package_names = file.read().splitlines()
    else:
        package_names = [args.p]

    for package_name in package_names:
        url2 = get_apk_url(package_name)
        if url2:
            download_apk(package_name, url2)

if __name__ == "__main__":
    main()
