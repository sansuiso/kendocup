module Kendocup
  class Cup < ActiveRecord::Base
    has_many :kenshis, inverse_of: :cup, dependent: :destroy
    has_many :participations, through: :kenshis
    has_many :individual_categories, inverse_of: :cup, dependent: :destroy
    has_many :team_categories, inverse_of: :cup, dependent: :destroy
    has_many :teams, through: :team_categories
    has_many :events, inverse_of: :cup, dependent: :destroy
    has_many :headlines, inverse_of: :cup, dependent: :destroy
    has_many :products, inverse_of: :cup, dependent: :destroy

    validates_presence_of :start_on
    validates_presence_of :deadline
    validates_presence_of :adult_fees_chf
    validates_presence_of :adult_fees_eur
    validates_presence_of :junior_fees_chf
    validates_presence_of :junior_fees_eur
    validates_uniqueness_of :start_on

    before_validation :set_deadline, :set_year

    def self.past
      where("cups.start_on < ?", Date.current)
    end

    def self.future
      where("cups.start_on >= ?", Date.current)
    end

    def to_param
      year
    end

    def to_s
      year.to_s
    end

    def past?
      start_on < Date.current
    end

    def junior_fees(currency)
      currency.to_sym == :chf ? self.junior_fees_chf : self.junior_fees_eur
    end

    def adult_fees(currency)
      currency.to_sym == :chf ? self.adult_fees_chf : self.adult_fees_eur
    end

  private

    def set_deadline
      self.deadline = (self.start_on.to_time-7.days) if self.start_on.present? && self.deadline.blank?
    end

    def set_year
      if self.year.blank?
        self.year = self.start_on.try(:year)
      end
    end
  end
end
