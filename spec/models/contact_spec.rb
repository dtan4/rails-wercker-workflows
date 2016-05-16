require "spec_helper"

describe Contact, type: :model do
  it "is valid with a firstname, lastname and email" do
    expect(build(:contact)).to be_valid
  end

  it "is invalid without a firstname" do
    contact = build(:contact, firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname].length).to eq 1
  end

  it "is invalid withour a lastname" do
    contact = build(:contact, lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname].length).to eq 1
  end

  it "is invalid without an email address" do
    contact = build(:contact, email: nil)
    contact.valid?
    expect(contact.errors[:email].length).to eq 1
  end

  it "is invalid with a duplicate email address" do
    create(:contact,
           firstname: "Joe", lastname: "Tester", email: "tester@example.com")
    contact = build(:contact, firstname: "Jane", lastname: "Tester", email: "tester@example.com")
    contact.valid?
    expect(contact.errors[:email].length).to eq 1
  end

  it "returns a contact's full name as a string" do
    contact = build(:contact, firstname: "John", lastname: "Doe")
    expect(contact.name).to eq "John Doe"
  end

  it "has three phone numbers" do
    expect(create(:contact).phones.size).to eq(3)
  end

  describe "filter last name by letter" do
    let(:smith) do
      create(:contact,
             firstname: "John",
             lastname: "Smith",
             email: "jsmith@example.com")
    end

    let(:jones) do
      create(:contact,
             firstname: "Tim",
             lastname: "Jones",
             email: "tjones@example.com")
    end

    let(:johnson) do
      create(:contact,
             firstname: "John",
             lastname: "Johnson",
             email: "jjohnson@example.com")
    end

    context "matching letters" do
      it "returns a sorted array of results that match" do
        expect(Contact.by_letter("J")).to eq [johnson, jones]
      end
    end

    context "non-mathing letters" do
      it "returns a sorted array of results that match" do
        expect(Contact.by_letter("J")).not_to include smith
      end
    end
  end

  describe "convert to CSV" do
    it "returns CSV" do
      create(:contact,
             firstname: "Aaron",
             lastname: "Sumnar",
             email: "aaron@sample.com")
      expect(Contact.to_csv).to match /Aaron Sumnar,aaron@sample.com/
    end
  end
end
