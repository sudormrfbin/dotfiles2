# This script doesn't work since reddit blocks programmatic
# access to it's pages, so anyways it has to be done through
# the browser

import sys

from omnivoreql import OmnivoreQL

TOKEN = ""
SEARCH_QUERY = "pardner"

client = OmnivoreQL(TOKEN)


def header_print(s):
    print(f"=> {s}")


def sub_print(s):
    print(f"   {s}")


header_print("Searching for reddit articles")
search_results = client.get_articles(query=SEARCH_QUERY)

articles = [d["node"] for d in search_results["search"]["edges"]]

if articles:
    sub_print(f"Found {len(articles)} articles")
else:
    sub_print("Exiting because zero articles were found")
    sys.exit(1)


header_print("Article URLs")
for article in articles:
    sub_print(article["url"])

for i, article in enumerate(articles):
    header_print(f"[{i}/{len(articles)}]")

    url = article["url"]
    sub_print(f"Deleting       {url}")
    client.delete_article(article["id"])
    # sub_print("Done")

    new_url = url.replace("www.reddit.com", "old.reddit.com")
    sub_print(f"Replacing with {new_url}")
    client.save_url(new_url)
    sub_print("Done")
