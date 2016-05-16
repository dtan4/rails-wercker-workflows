class Contact < ActiveRecord::Base
  has_many :phones
  accepts_nested_attributes_for :phones

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phones, length: { is: 3 }

  def name
    [firstname, lastname].join(' ')
  end

  def self.by_letter(letter)
    if letter
      where("lastname LIKE ?", "#{letter}%").order(:lastname)
    else
      all.order("lastname, firstname")
    end
  end

  def self.to_csv(contacts = Contact.all)
    CSV.generate do |csv|
      contacts.each { |contact| csv << [contact.name, contact.email] }
    end
  end
end
