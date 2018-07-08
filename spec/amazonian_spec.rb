RSpec.describe Amazonian do
  it "has a version number" do
    expect(Amazonian::VERSION).not_to be nil
  end

  it "makes a web request to the correct Amazon product: Baby Banana Infant Training Toothbrush and Teether, Yellow" do
    expect(Amazonian::Client.new("B002QYW8LW").call).to eq({:best_sellers_rank=>[{:rank=>2, :ladder=>"Baby > Baby Care > Pacifiers, Teethers & Teething Relief > Teethers"}, {:rank=>2, :ladder=>"Baby > Baby Care > Health"}], :rank=>12, :category=>"Baby", :package_dimensions=>"4.3 x 0.4 x 7.9 inches"})
  end

  it "makes a web request to the correct Amazon product: Baby Teether Toys BPA Free" do
    expect(Amazonian::Client.new("B078SX6STW").call).to eq({:best_sellers_rank=>[{:rank=>52, :ladder=>"Baby > Baby Care > Pacifiers, Teethers & Teething Relief > Teethers"}], :rank=>1736, :category=>"Baby", :package_dimensions=>"6.8 x 6.3 x 1.9 inches"})
  end

  it "makes a web request to the correct Amazon product: Starter Boys' Short Sleeve Americana Logo T-Shirt" do
    expect(Amazonian::Client.new("B071G4JX2X").call).to eq({:best_sellers_rank=>[{:rank=>2732, :ladder=>"Clothing, Shoes & Jewelry > Boys > Clothing > Tops & Tees > Tees"}], :rank=>908282, :category=>"Clothing, Shoes & Jewelry", :package_dimensions=>"1 x 1 x 1 inches"})
  end

  it "makes a web request to the correct Amazon product: AmazonBasics Stainless Steel Electric Kettle" do
    expect(Amazonian::Client.new("B072DWYBL7").call ).to eq({:best_sellers_rank=>[{:rank=>1, :ladder=>"Kitchen & Dining > Coffee, Tea & Espresso > Electric Kettles"}], :rank=>8, :category=>"Kitchen & Dining", :package_dimensions=>"8 x 5.5 x 7.9 inches"})
  end

  it "makes a web request to a missing Amazon product raises error" do
    expect{ Amazonian::Client.new("B002QYW8L2").call }.to raise_error{ Amazonian::ProductNotFoundError }
  end
end