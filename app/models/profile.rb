# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  country    :string(60)       not null
#  first_name :string(60)       not null
#  headline   :string(200)      not null
#  last_name  :string(60)       not null
#  location   :string(100)      not null
#  slug       :string(100)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Profile < ApplicationRecord
  validates :first_name, presence: true, length: { in: 2..60 }
  validates :last_name, presence: true, length: { in: 2..60 }
  validates :headline, presence: true, length: { in: 2..200 }
  validates :country, presence: true, length: { in: 2..60 }
  validates :location, presence: true, length: { in: 2..100 }
  validates :slug, presence: true, length: { in: 2..100 }, uniqueness: true

  before_validation :generate_slug, on: :create

  def to_param
    slug
  end

  private

    def generate_slug
      loop do
        self.slug = "#{first_name} #{last_name} #{SecureRandom.random_number}".parameterize
        break unless self.class.where(slug: slug).exists?
      end
    end
end
