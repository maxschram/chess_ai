class Employee

  attr_reader :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
    boss.employees << self if boss
  end

  def bonus(multiplier)
    salary * multiplier
  end

  def all_sub_employees
    []
  end
end

class Manager < Employee

  attr_accessor :employees

  def initialize(name, title, salary, boss, employees = [])
    super(name, title, salary, boss)
    @employees = employees
  end

  def bonus(multiplier)
    total_subordinate_salary * multiplier
  end

  protected

  def all_sub_employees
    # return [] if employees.empty?

    sub_employees = []
    employees.each do |employee|
      sub_employees << employee
      sub_employees << employee.all_sub_employees
    end
    sub_employees.flatten
  end

  def total_subordinate_salary
    all_sub_employees.reduce(0) do |total_salary, employee|
      total_salary + employee.salary
    end
  end
end
