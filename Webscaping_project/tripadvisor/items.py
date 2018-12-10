from scrapy.item import Item, Field

import unicodedata
import re


import scrapy


class HotelItem(scrapy.Item):
    # Items to get
    hotel_name = scrapy.Field()
    ratings = scrapy.Field()
    review = scrapy.Field()
    address = scrapy.Field()



