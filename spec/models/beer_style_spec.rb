require "spec_helper"

describe BeerStyle do
  it { should have_many(:beers) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(255) }
  it { should allow_mass_assignment_of(:name) }

  it { should validate_presence_of(:description) }
  it { should ensure_length_of(:description).is_at_most(4096) }
  it { should allow_mass_assignment_of(:description) }

  it "includes SearchableModel" do
    BeerStyle.included_modules.should include(SearchableModel)
  end

  it "includes BeerAssociation" do
    BeerStyle.included_modules.should include(BeerAssociation)
  end
end

describe Brewery, ".filter_by_name" do
  let(:pilsner)    { create(:beer_style, name: "Pilsner") }
  let(:porter)     { create(:beer_style, name: "Porter") }
  let!(:beer_styles) { [pilsner, porter] }

  it "filters results" do
    BeerStyle.filter_by_name("Pilsner").should == [pilsner]
  end

  it "filters results, ignoring case" do
    BeerStyle.filter_by_name("PORTer").should == [porter]
  end

  it "filters results, with wildcard matches" do
    BeerStyle.filter_by_name("p").should == beer_styles
  end

  it "does not filter results if no name is provided" do
    BeerStyle.filter_by_name("").should  == beer_styles
    BeerStyle.filter_by_name(" ").should == beer_styles
    BeerStyle.filter_by_name(nil).should == beer_styles
  end
end

describe BeerStyle, ".for_token" do
  let!(:user)    { create(:user) }
  let!(:pilsner) { create(:beer_style, user: nil) }
  let!(:porter)  { create(:beer_style, user: user) }

  before do
    User.stubs(:find_by_public_or_private_token)
  end

  it "includes public and private beer styles, provided a valid token" do
    User.stubs(find_by_public_or_private_token: user)
    BeerStyle.for_token("valid").should == [pilsner, porter]
    User.should have_received(:find_by_public_or_private_token).with("valid")
  end

  it "includes public beer styles, provided an invalid token" do
    BeerStyle.for_token("invalid").should == [pilsner]
    User.should have_received(:find_by_public_or_private_token).with("invalid")
  end

  it "includes public beer styles, provided no token" do
    BeerStyle.for_token(nil).should == [pilsner]
    User.should have_received(:find_by_public_or_private_token).never
  end
end

describe BeerStyle, ".search" do
  let(:scope) { stub }

  before do
    BeerStyle.stubs(for_token: scope)
    scope.stubs(page:           scope,
                order_by:       scope,
                per_page:       scope,
                filter_by_name: scope)
  end

  it "includes records for the token" do
    BeerStyle.search(token: "token")
    BeerStyle.should have_received(:for_token).with("token")
  end

  it "filters by name using the query" do
    BeerStyle.search(query: "query")
    scope.should have_received(:filter_by_name).with("query")
  end

  it "limits the query to a specific page" do
    BeerStyle.search
    scope.should have_received(:page).with(nil)
    BeerStyle.search(page: 2)
    scope.should have_received(:page).with(2)
  end

  it "limits the number of records per page" do
    BeerStyle.search
    scope.should have_received(:per_page).with(50)
    BeerStyle.search(per_page: 1)
    scope.should have_received(:per_page).with(1)
  end

  it "sorts the results" do
    BeerStyle.search(order: "order")
    scope.should have_received(:order_by).with("order")
  end

  it "returns the scope" do
    BeerStyle.search({}).should == scope
  end
end

describe BeerStyle, ".order_by" do
  let(:pilsner)    { create(:beer_style, name: "Pilsner") }
  let(:porter)     { create(:beer_style, name: "Porter") }
  let!(:name_asc)  { [pilsner, porter] }
  let!(:name_desc) { [porter, pilsner] }

  it "orders beer styles" do
    BeerStyle.order_by("name asc").should == name_asc
    BeerStyle.order_by("name desc").should == name_desc
  end

  it "cleans the order string" do
    BeerStyle.stubs(clean_order: "id ASC")
    BeerStyle.order_by("fake desc").should == name_asc
    BeerStyle.should have_received(:clean_order).with("fake desc")
  end
end

describe BeerStyle, "being destroyed" do
  subject { create(:beer_style) }

  it "is destroyed when it has zero beers" do
    subject.destroy.should be_true
  end

  it "is not destroyed when it has beers" do
    create(:beer, brewery: create(:brewery), beer_style: subject)
    subject.destroy.should be_false
  end
end

describe BeerStyle, "#public?" do
  it "returns true when no user is present" do
    create(:beer_style, user: nil).should be_public
  end

  it "returns false when a user is present" do
    create(:beer_style, user: build(:user)).should_not be_public
  end
end
