RSpec.describe Amazoned do
  it "has a version number" do
    expect(Amazoned::VERSION).not_to be nil
  end


  let(:keys) { %i(category asin rank) }
  let(:best_seller_keys) { %i(rank ladder)}


  it "makes a web request to the correct Amazon product: Baby Banana Infant Training Toothbrush and Teether, Yellow" do
    response = Amazoned::Client.new("B002QYW8LW").call
    category = "Baby"
    categories = ["Baby > Baby Care > Health", "Baby > Baby Care > Pacifiers, Teethers & Teething Relief > Teethers"]
    expect( response[:category] ).to eq(category)
    expect( response[:rank] ).to be_an_instance_of(Integer)
    expect( response[:package_dimensions] ).to eq("4.3 x 0.4 x 7.9 inches")
    expect( response[:best_sellers_rank] ).to be_present
    expect( response[:best_sellers_rank].first.keys ).to contain_exactly(*best_seller_keys)
    expect( response[:best_sellers_rank].any? {|h| categories.include?(h[:ladder]) }).to eq(true)
  end

  it "makes a web request to the correct Amazon product: Baby Teether Toys BPA Free" do
    response = Amazoned::Client.new("B078SX6STW").call
    category = "Baby"
    categories = ["Baby > Baby Care > Pacifiers, Teethers & Teething Relief > Teethers"]
    expect( response[:category] ).to eq(category)
    expect( response[:rank] ).to be_an_instance_of(Integer)
    expect( response[:package_dimensions] ).to eq("6.8 x 6.3 x 1.9 inches")
    expect( response[:best_sellers_rank] ).to be_present
    expect( response[:best_sellers_rank].first.keys ).to contain_exactly(*best_seller_keys)
    expect( response[:best_sellers_rank].any? {|h| categories.include?(h[:ladder]) }).to eq(true)
  end

  it "makes a web request to the correct Amazon product: Starter Boys' Short Sleeve Americana Logo T-Shirt" do
    response = Amazoned::Client.new("B071G4JX2X").call
    category = "Clothing, Shoes & Jewelry"
    categories = ["Clothing, Shoes & Jewelry > Boys > Clothing > Tops & Tees > Tees"]
    expect( response[:category] ).to eq(category)
    expect( response[:rank] ).to be_an_instance_of(Integer)
    expect( response[:package_dimensions] ).to eq("1 x 1 x 1 inches")
    expect( response[:best_sellers_rank] ).to be_present
    expect( response[:best_sellers_rank].first.keys ).to contain_exactly(*best_seller_keys)
    expect( response[:best_sellers_rank].any? {|h| categories.include?(h[:ladder]) }).to eq(true)
  end

  it "makes a web request to the correct Amazon product: AmazonBasics Stainless Steel Electric Kettle" do
    response = Amazoned::Client.new("B072DWYBL7").call
    category = "Kitchen & Dining"
    categories = ["Kitchen & Dining > Coffee, Tea & Espresso > Electric Kettles"]
    expect( response[:category] ).to eq(category)
    expect( response[:rank] ).to be_an_instance_of(Integer)
    expect( response[:package_dimensions] ).to eq("8 x 5.5 x 7.9 inches")
    expect( response[:best_sellers_rank] ).to be_present
    expect( response[:best_sellers_rank].first.keys ).to contain_exactly(*best_seller_keys)
    expect( response[:best_sellers_rank].any? {|h| categories.include?(h[:ladder]) }).to eq(true)
  end

  it "makes a web request to the correct Amazon product: UBTECH Astrobot Kit Interactive Robotic Building Block System" do
    response = Amazoned::Client.new("B0714NGKTB").call
    category = "Toys & Games"
    categories = [
      "Toys & Games > Learning & Education > Science > Robotics",
      "Amazon Launchpad > Toys"
    ]
    expect( response[:category] ).to eq(category)
    expect( response[:rank] ).to be_an_instance_of(Integer)
    expect( response[:package_dimensions] ).to eq("8 x 6 x 8 inches")
    expect( response[:best_sellers_rank] ).to be_present
    expect( response[:best_sellers_rank].first.keys ).to contain_exactly(*best_seller_keys)
    expect( response[:best_sellers_rank].any? {|h| categories.include?(h[:ladder]) }).to eq(true)
  end

  xit "makes a web request to the correct Amazon product: Remington PG6025 All-in-1 Lithium Powered Grooming Kit, Trimmer" do
    response = Amazoned::Client.new("B00H2B4H2M").call
    category = "Beauty & Personal Care"
    categories = [
      "Beauty & Personal Care > Tools & Accessories > Shave & Hair Removal > Men's > Beard & Mustache Care > Beard & Mustache Trimmers",
      "Beauty & Personal Care > Tools & Accessories > Shave & Hair Removal > Women's > Epilators, Groomers & Trimmers > Personal Groomers",
      "Beauty & Personal Care > Hair Care > Hair Cutting Tools > Hair Clippers & Accessories"
    ]
    expect( response[:category] ).to eq(category)
    expect( response[:rank] ).to be_an_instance_of(Integer)
    expect( response[:package_dimensions] ).to eq("3 x 9.2 x 4.5 inches")
    expect( response[:best_sellers_rank] ).to be_present
    expect( response[:best_sellers_rank].first.keys ).to contain_exactly(*best_seller_keys)
    expect( response[:best_sellers_rank].any? {|h| categories.include?(h[:ladder]) }).to eq(true)
  end

  it "makes a web request to a missing Amazon product raises error" do
    expect{ Amazoned::Client.new("B002QYW8L2").call }.to raise_error{ Amazoned::ProductNotFoundError }
  end
end