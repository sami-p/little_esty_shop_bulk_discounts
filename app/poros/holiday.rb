class Holiday
  attr_reader :first_three

  def initialize(repo_data)
    @first_three = repo_data[0..2]
  end
end
