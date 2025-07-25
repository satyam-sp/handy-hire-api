class AddJidToInstantJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :instant_jobs, :jid, :string
    add_index :instant_jobs, :jid
  end
end
