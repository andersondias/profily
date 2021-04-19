# == Schema Information
#
# Table name: profiles
#
#  id                  :bigint           not null, primary key
#  country             :string(60)       not null
#  first_name          :string(60)       not null
#  headline            :string(200)      not null
#  last_name           :string(60)       not null
#  location            :string(100)      not null
#  slug                :string(100)      not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  original_profile_id :bigint
#
# Indexes
#
#  index_profiles_on_original_profile_id  (original_profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (original_profile_id => profiles.id)
#
class Profile < ApplicationRecord
  default_scope { where(original_profile_id: nil) }
  scope :with_drafts, -> { unscoped }
  scope :drafts, -> { unscoped.where.not(original_profile_id: nil) }

  validates :first_name, presence: true, length: { in: 2..60 }
  validates :last_name, presence: true, length: { in: 2..60 }
  validates :headline, presence: true, length: { in: 2..200 }
  validates :country, presence: true, length: { in: 2..60 }
  validates :location, presence: true, length: { in: 2..100 }
  validates :slug, presence: true,
    length: { in: 2..100 },
    uniqueness: { conditions: -> (profile) {
      if profile.original_profile_id
        where.not(id: profile.original_profile_id)
      else
        where(original_profile_id: nil)
      end
    } },
    format: { with: /\A[a-zA-Z0-9\-]+\z/ }

  before_validation :generate_slug, on: :create
  after_update :delete_draft

  belongs_to :original_profile, class_name: 'Profile', optional: true
  has_one :draft, class_name: 'Profile', foreign_key: 'original_profile_id', dependent: :delete

  accepts_nested_attributes_for :draft

  def to_param
    slug_was || slug
  end

  private

    def validates_unique_slug?
      original_profile.blank? || original_profile.slug != self.slug
    end

    def generate_slug
      if original_profile_id.present?
        self.slug ||= original_profile.slug
        return
      end

      loop do
        self.slug = "#{first_name} #{last_name} #{SecureRandom.random_number}".parameterize
        break unless self.class.where(slug: slug).exists?
      end
    end

    def delete_draft
      previous_changes.present? && draft && draft.delete
    end
end
