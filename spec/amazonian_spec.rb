RSpec.describe Amazoned do
  it "has a version number" do
    expect(Amazoned::VERSION).not_to be nil
  end

  it "makes a web request to the correct Amazon product: Baby Banana Infant Training Toothbrush and Teether, Yellow" do
    expect(Amazoned::Client.new("B002QYW8LW").call).to eq({:best_sellers_rank=>[{:rank=>2, :ladder=>"Baby > Baby Care > Pacifiers, Teethers & Teething Relief > Teethers"}, {:rank=>2, :ladder=>"Baby > Baby Care > Health"}], :rank=>15, :category=>"Baby", :package_dimensions=>"4.3 x 0.4 x 7.9 inches"})
  end

  it "makes a web request to the correct Amazon product: Baby Teether Toys BPA Free" do
    expect(Amazoned::Client.new("B078SX6STW").call).to eq({:best_sellers_rank=>[{:rank=>51, :ladder=>"Baby > Baby Care > Pacifiers, Teethers & Teething Relief > Teethers"}], :rank=>1717, :category=>"Baby", :package_dimensions=>"6.8 x 6.3 x 1.9 inches"})
  end

  it "makes a web request to the correct Amazon product: Starter Boys' Short Sleeve Americana Logo T-Shirt" do
    expect(Amazoned::Client.new("B071G4JX2X").call).to eq({:best_sellers_rank=>[{:rank=>3206, :ladder=>"Clothing, Shoes & Jewelry > Boys > Clothing > Tops & Tees > Tees"}], :rank=>1039729, :category=>"Clothing, Shoes & Jewelry", :package_dimensions=>"1 x 1 x 1 inches"})
  end

  it "makes a web request to the correct Amazon product: AmazonBasics Stainless Steel Electric Kettle" do
    expect(Amazoned::Client.new("B072DWYBL7").call ).to eq({:best_sellers_rank=>[{:rank=>1, :ladder=>"Kitchen & Dining > Coffee, Tea & Espresso > Electric Kettles"}], :rank=>20, :category=>"Kitchen & Dining", :package_dimensions=>"8 x 5.5 x 7.9 inches"})
  end

  it "makes a web request to the correct Amazon product: AmazonBasics Stainless Steel Electric Kettle" do
    expect(Amazoned::Client.new("B0714NGKTB").call ).to eq({:best_sellers_rank=>[{:rank=>127, :ladder=>"Toys & Games > Learning & Education > Science > Robotics"}, {rank: 553, :ladder => "Amazon Launchpad > Toys"}], :rank=>116425, :category=>"Toys & Games", :package_dimensions=>"8 x 6 x 8 inches"})
  end

  it "makes a web request to a missing Amazon product raises error" do
    expect{ Amazoned::Client.new("B002QYW8L2").call }.to raise_error{ Amazoned::ProductNotFoundError }
  end
end