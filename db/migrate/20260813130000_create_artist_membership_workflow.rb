class CreateArtistMembershipWorkflow < ActiveRecord::Migration[6.0]
  def change
    create_table :artist_membership_applications do |t|
      t.string :applicant_email, null: false
      t.string :display_name, null: false
      t.string :status, null: false, default: 'draft'
      t.boolean :education_verified, null: false, default: false
      t.text :statement
      t.text :moderator_summary
      t.datetime :submitted_at
      t.datetime :decided_at
      t.timestamps

      t.index :applicant_email
      t.index :status
    end

    create_table :artist_portfolio_works do |t|
      t.references :artist_membership_application, null: false, foreign_key: true
      t.string :category, null: false
      t.string :title, null: false
      t.string :technique
      t.integer :year_created
      t.text :author_note
      t.timestamps

      t.index [:artist_membership_application_id, :category]
    end

    create_table :artist_reviews do |t|
      t.references :artist_membership_application, null: false, foreign_key: true
      t.string :reviewer_name, null: false
      t.string :category, null: false
      t.integer :score, null: false
      t.text :comment, null: false
      t.boolean :visible_to_applicant, null: false, default: false
      t.timestamps

      t.index [:artist_membership_application_id, :category], name: 'index_artist_reviews_on_application_and_category'
    end
  end
end
