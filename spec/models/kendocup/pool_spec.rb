require 'spec_helper'

module Kendocup
  RSpec.describe Pool, type: :model do

    let(:individual_category) {create :kendocup_individual_category}
    let(:participation1) {create :kendocup_participation, category: individual_category, kenshi: create(:kendocup_kenshi, grade: "kyu", cup: individual_category.cup)}
    let(:participation2) {create :kendocup_participation, category: individual_category, kenshi: create(:kendocup_kenshi, grade: "kyu", cup: individual_category.cup)}
    let(:participation3) {create :kendocup_participation, category: individual_category, kenshi: create(:kendocup_kenshi, grade: "kyu", cup: individual_category.cup)}
    let(:pool){Pool.new number: 3, participations: [participation1, participation2, participation3]}
    it {expect(pool).to_not be_contains_high_rank}

    context "with an high rank" do
      before {participation3.kenshi.update_attributes grade: "5Dan"}
      it {expect(pool).to be_contains_high_rank}
    end
  end
end
