require 'spec_helper'

module Kendocup
  RSpec.describe Kenshi, type: :model do
    let(:cup){create :kendocup_cup, start_on: 10.years.since}
    before {create :kendocup_kenshi}
    it {should belong_to :cup}
    it {should belong_to :user}
    it {should belong_to :club}
    it {should have_many(:participations).dependent(:destroy)}
    it {should have_many(:individual_categories).through(:participations)}
    it {should have_many(:teams).through(:participations)}
    it {should have_many(:purchases).dependent(:destroy)}
    it {should have_many(:products).through(:purchases)}

    it {should respond_to :first_name}
    it {should respond_to :last_name}
    it {should respond_to :dob}
    it {should respond_to :club}
    it {should respond_to :grade}
    it {should respond_to :email}
    it {should respond_to :remarks}

    it {should validate_presence_of :cup_id}
    it {should validate_presence_of :user_id}
    it {should validate_presence_of :first_name}
    it {should validate_presence_of :last_name}
    it {should validate_presence_of :dob}
    it {should validate_presence_of :club}
    it {should validate_presence_of :grade}
    it {should validate_uniqueness_of(:last_name).scoped_to :cup_id, :first_name }

    it { should validate_inclusion_of(:grade).in_array Kenshi::GRADES }
    # it { should ensure_inclusion_of(:female).in_array [true, false] }

    it {should act_as_fighter}

    describe "A kenshi" do
      let(:cup){create :kendocup_cup, start_on: "#{Date.current.year}-12-29"}
      let(:club){create :kendocup_club, name: "Shung Do Kwan"}
      let(:kenshi){create :kendocup_kenshi, first_name: "Yannis", last_name: "Jaquet", female: false, club: club, dob: 20.years.ago, cup: cup}
      it {expect(kenshi).to be_valid_verbose}
      it {expect(kenshi.full_name).to eq "Yannis Jaquet"}
      it { expect(kenshi).to be_adult }
      it { expect(kenshi.age_at_cup).to eq 20 }
      it { expect(kenshi.club.name).to eq "Shung Do Kwan" }
      it { expect(kenshi.poster_name).to eq "JAQUET" }

      context "updated as junior" do
        before {
          kenshi.update_attributes dob: 12.years.ago
        }
        it { expect(kenshi).to be_junior }
        it { expect(kenshi.age_at_cup).to eq 12 }
      end
    end

    describe "A kenshi with badly formatted name and email" do
      let(:kenshi){create :kendocup_kenshi, first_name: "FIRST-J.-sébastien mÜhlebäch", last_name: "LAST-J.-name nAme", email: 'STUPIDLY.FORAMaTTED@EMAIL.COM', cup: cup}

      it {expect(kenshi.norm_last_name).to eq 'Last-J.-Name Name'}
      it {expect(kenshi.norm_first_name).to eq 'First-J.-Sébastien MÜhlebäch'}
      it {expect(kenshi.full_name).to eq "First-J.-Sébastien MÜhlebäch Last-J.-Name Name"}
      it {expect(kenshi.reload.email).to eq 'stupidly.foramatted@email.com'}
    end

    describe "Updating a kenshi with participations data" do
      let(:kenshi){create :kendocup_kenshi, first_name: "Yannis", last_name: "Jaquet", female: false, cup: cup}
      let(:individual_category) {create :kendocup_individual_category, cup: kenshi.cup}
      let(:team_category) {create :kendocup_team_category, cup: kenshi.cup}

      context "creating a team and an individual participations" do
        before(:each) {
          kenshi.update_attributes individual_category_ids: [individual_category.id], participations_attributes: {"0" => {category_type: "Kendocup::TeamCategory", category_id: team_category.id, team_name: "sdk1"}}
        }

        it {
          kenshi.participations.each do |participation|
            expect(participation).to be_valid_verbose
          end
        }

        it {expect(kenshi.participations.count).to eql 2}
        it {expect(kenshi.participations.map{|p| p.category.name}).to match_array [individual_category.name, team_category.name]}
        it {expect(kenshi.individual_categories.count).to eql 1}
        it {expect(kenshi.takes_part_to? individual_category).to be true}
        it {expect(kenshi.competition_fee(:chf)).to eql 30}
        it {expect(kenshi.competition_fee(:eur)).to eql 25}
        it { expect(kenshi).to be_adult}
        it {expect(kenshi.fees(:chf)).to eql 30}
        it {expect(kenshi.fees(:eur)).to eql 25}


        context "with a purchase" do
          let(:product){create :kendocup_product, cup: kenshi.cup}
          before {
            kenshi.update_attributes product_ids: [product.id]
            # kenshi.reload
          }

          it {expect(kenshi).to be_valid_verbose}

          it {expect(kenshi.products.count).to eq 1}
          it {expect(kenshi.products_fee(:chf)).to eql 10}
          it {expect(kenshi.products_fee(:eur)).to eql 8}
          it {expect(kenshi.fees(:chf)).to eql 40}
          it {expect(kenshi.fees(:eur)).to eql 33}
          it {expect(kenshi.purchased?(product)).to be true}
        end

        context "and deleting the team participation" do
          before {
            kenshi.update_attributes participations_attributes: {"0" => {id: kenshi.participations.first.id, _destroy: 1}}
          }
          it {expect(kenshi.participations.count).to eq 1}
        end
      end
    end
    describe "fitness" do
      context "kenshi aged 20 and 0Dan" do
        let (:kenshi) { build :kendocup_kenshi, dob: 20.years.ago, grade: "kyu", cup: cup}
        it {expect(kenshi.fitness).to eql 0.0}
      end
      context "kenshi aged 20 and 1Dan" do
        let (:kenshi) { build :kendocup_kenshi, dob: 20.years.ago, grade: "1Dan", cup: cup}
        it {expect(kenshi.fitness).to eql 0.0333}
      end
      context "kenshi aged 20 and 3Dan" do
        let (:kenshi) { build :kendocup_kenshi, dob: 20.years.ago, grade: "3Dan", cup: cup}
        it {expect(kenshi.fitness).to eql 0.1}
      end
      context "kenshi aged 60 and 8Dan" do
        let (:kenshi) { build :kendocup_kenshi, dob: 60.years.ago, grade: "3Dan", cup: cup}
        it {expect(kenshi.fitness).to eql 0.0429}
      end
    end
  end
end
