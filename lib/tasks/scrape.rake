namespace :scrape do 
  require "net/http"
  require "uri"


  desc "scraping mybirthdayfacts.com"
  # must send by soap 
  task :bdfacts => :environment do

    url = "http://www.mybirthdayfacts.com/MBFService.asmx"

    theXml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><FetchFacts xmlns="http://www.mybirthdayfacts.com"><dayStr>18</dayStr><monthStr>7</monthStr><yearStr>1975</yearStr></FetchFacts></soap:Body></soap:Envelope>'
    
    response = post_xml(url, theXml)
    puts response
  end

  def post_xml(path, xml)
    host = "http://www.mybirthdayfacts.com"
    http = Net::HTTP.new(host)
    resp = http.post(path, xml, { 'Content-Type' => 'text/xml; charset=utf-8' })
    return resp.body
  end


  desc "scrape wiki for articles"
  task :wiki => :environment do

    require 'open-uri'
    require 'nokogiri'
    require 'date'
    
    dayStr = "18"
    monthStr = "July"
    yearStr = "1975"
    url = "http://en.wikipedia.org/wiki/" + monthStr + "_" + yearStr
    

    begin
      document = open(url).read
      html_doc = Nokogiri::HTML(document)
      puts html_doc.css('title')
    rescue OpenURI::HTTPError => ex
      puts "Missing URL"
      return
    end
    

    # jquery
    # $("span#July_18\\.2C_1975_\\.28Friday\\.29").parent().next()
    
    data_links = "div#mw-content-text"
    links = html_doc.css(data_links)
    # puts links

    # might be trouble to independently find which day of the week
    # findDayOfWeek(dayStr, monthStr, yearStr);
    # data_article_link = monthStr + "_" + dayStr + ".2C_" + yearStr + "_.28" + dayOfWeek + ".29"
    # data_href_link = "/wiki/" + monthStr + "_" + dayStr
    # aString = 'July_18.2C_1975_.28Friday.29'
    aString = monthStr + "_" + dayStr
    # aString = concat(monthStr + '_' + dayStr)
    article_links = html_doc.xpath("//span[contains(@id, '#{aString}')]")
    # article_links = html_doc.at_css(aString).parent
    # # article_links = html_doc.css(data_href_link)
    puts article_links
    puts aString
    # number_articles = article_links.count
    # puts "number of article links " + number_articles.to_s

    # structure is
    # <h2><span> with id inc day of the week <a href with just month & day>
    #  then <ul> with articles directly under

  end


end
