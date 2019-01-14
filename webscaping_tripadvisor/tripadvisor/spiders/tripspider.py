import scrapy
from tripadvisor.items import HotelItem
from scrapy import Request
import re

class TripAdvisorReview(scrapy.Spider):
    name = "tripadvisorspider"
    #allowed_domains = ["tripadvisor.co.za"]
    start_urls = ["https://www.tripadvisor.co.za/Hotels-g1722390-Cape_Town_Western_Cape-Hotels.html"
          ]

    def parse(self, response):
        for href in response.xpath('//div[@class="listing_title"]/a/@href').extract():
            urls = response.urljoin(href)
            #for url in urls:
            yield scrapy.Request(urls, callback=self.parse_review)


    def parse_review(self, response):

        item = HotelItem()
        hotel=response.xpath('//h1[@id = "HEADING"]/text()').extract()
        review=response.xpath('//span[@class="noQuotes"]/text()').extract()[0:5]
        address=response.xpath('//span[@class="street-address"]/text()').extract()[0]
        ratings=response.xpath('.//span[contains(@class,"ui_bubble_rating")]/@alt').extract()[0].replace('bubble', 'star')
        # = response.xpath('//div[@class="quote"]/text()').extract()[0][1:-1] #strip the quotes (first and last char)
        #content = response.xpath('//div[@class="entry"]/p').extract()[0]
        #content = contents[0].encode("utf-8")
        
       
        item['hotel_name']=hotel
        item['ratings']=ratings
        item['review']=review
        item['address']=address
        
        return item
