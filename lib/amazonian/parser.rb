class Amazonian::Parser
  attr_accessor :product_hash
  attr_reader :html_doc, :response

  def initialize(response)
    @product_hash = Hash.new
    @response = response
    @html_doc = Nokogiri::HTML(response.body)
  end

  def call
    parse_response_for_product_details( response )
  end

  def parse_response_for_product_details(response)
    product_hash[:best_sellers_rank] = []

    ########
    # # Parent category Seller Rank Parser
    ########
    parsed_parent_category = html_doc.css('#SalesRank').text.partition("(").first.chop.partition("#").last.partition("in").map(&:strip) - ["in"]
    product_hash[:rank] = parsed_parent_category.first.delete(',').to_i # "903,610" -> 903610
    product_hash[:category] = parsed_parent_category.last

    ########
    # # Subcategory Seller Rank Parser
    ########
    extract_subcategory_rankings( html_doc.css('.zg_hrsr_item') )

    ########
    # # Package Dimension Parser
    ########
    # Package Dimension Parsing Strategy 1:
    product_hash[:package_dimensions] = html_doc.css('.size-weight').children.map{|r| r.text}.reject{|r| !r.match?("inches")}.first

    # Package Dimension Parsing Strategy 2:
    if product_hash[:package_dimensions].blank?

      # Find an index for the string "Package Dimensions" within a string text extraction of the page
      str_index = html_doc.inner_text.index("Package Dimensions")

      unless str_index.nil?

        # Reduce string representing the html page down to a smaller target string including "Package Dimensions" and the weights
        str = html_doc.inner_text[str_index .. str_index + 150]

        # Find within target string an index for where the word "inches" appears, then grab characters around it
        product_hash[:package_dimensions] = str[str.index("inches")- 20.. str.index("inches")+8].strip
      end
    end

    # Package Dimension Parsing Strategy 3:
      response.search('.//*[@class="a-color-secondary a-size-base prodDetSectionEntry"]').map{|n| n.parent}.each do |n|

        # Parse html in each row of Amazon's product details table to get back a string. E.g:  "\n    \n        Best Sellers Rank\n    \n    \n         \n              \n #63 in Toys & Games (See Top 100 in Toys & Games)\n        \n              \n #3 in Toys & Games > Baby & Toddler Toys > Teethers\n        \n              \n        \n    \n    "
        str = n.children.inner_text
        if product_hash[:best_sellers_rank].blank?
          str.match("Best Sellers Rank") do |m|
            # Gnarly string manipulation extracts the array: ["63", "in", "Toys & Games"]
            parsed_parent_category = str.partition("(").first.chop.partition("#").last.partition("in").map(&:strip)

            # From ["63", "in", "Toys & Games"] we only care about first & last parts of this array
            product_hash[:rank] = parsed_parent_category.first.delete(',').to_i
            product_hash[:category] = parsed_parent_category.last

            parsed_category = str.partition(")").last.partition("in").map(&:strip).map{|i| i.gsub("#", "")} - ["in"]

            hsh = {}
            hsh[:rank] = parsed_category.first.delete(',').to_i
            hsh[:ladder] = parsed_category.last
            product_hash[:best_sellers_rank] << hsh
          end
        end

        if product_hash[:product_dimensions].blank?

          # Use pattern matching to extract the product details we care about
          str.match("Product Dimensions") do |m|
            product_hash[:package_dimensions] = str[str.index("inches")- 20.. str.index("inches")+8].strip
          end
        end
      end
    product_hash
  end

  def extract_subcategory_rankings(nokogiri_html)
    # Below is gnarly string manipulation to parse text strings like:
    # "\n    #2\n    in Baby > Baby Care > Health\n    \n    #2\n    in Baby > Baby Care > Pacifiers, Teethers & Teething Relief > Teethers\n    "
    # into:
    # [["2", "Baby > Baby Care > Health"], ["2", "Baby > Baby Care > Pacifiers, Teethers & Teething Relief > Teethers"]]
    nokogiri_html
    .map{|i| i.text}
    .map{|i| i.partition("in")
    .map(&:strip)}
    .map{|i| i - ["in"] }
    .map{|i|
      i.map{|ii|
        ii.gsub("#", "") # remove '#' from '#2'
        .gsub("\u00A0", "") # remove No-Break Space Unicode characters (U+00A0) since Ruby's .strip command won't remove them
      }
    }.each do |i|
      hsh = {}
      hsh[:rank] = i.first.to_i
      hsh[:ladder] = i.last
      product_hash[:best_sellers_rank] << hsh
    end
  end

end