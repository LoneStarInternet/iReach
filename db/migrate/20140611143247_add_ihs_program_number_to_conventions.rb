class AddIhsProgramNumberToConventions < ActiveRecord::Migration
  def change
    add_column :conventions, :ihs_program_number, :string
  end
end
