module RailsWizardSupport
  extend ActiveSupport::Concern

  class Step
    attr_reader :name, :title
    alias to_sym name
    alias to_s title

    def initialize(name, title)
      @name  = name.to_sym
      @title = title
    end
  end

  included do
    class_attribute :all_steps, :all_steps_by_name
    self.all_steps = []
    self.all_steps_by_name = {}
  end

  module ClassMethods
    def define_step(name, title = nil)
      step = Step.new(name.to_sym, title || name.to_s.humanize)
      all_steps << step
      all_steps_by_name[name] = step
      class_eval(%Q{
        def on_#{name}_page?
          current_step.nil? || current_step.name == :'#{name}'
        end
      })
    end

    def first_step
      all_steps[0]
    end
  end


  def possible_steps
    self.metaclass.all_steps.map do |step|
      step.name
    end
  end

  def has_step?(name)
    !!find_step(name)
  end

  def find_step(name)
    found_name = possible_steps.find { |step_name| step_name.to_s == name.to_s }
    if found_name
      metaclass.all_steps_by_name[found_name]
    else
      nil
    end
  end

  def find_step_index(name)
    possible_steps = self.possible_steps
    possible_steps.find_index { |step_name| step_name.to_s == name.to_s }
  end

  def current_step
    @current_step
  end

  def current_step=(step_name)
    if step_name
      if step = find_step(step_name)
        @current_step = step
      else
        raise "Step '#{step_name}' not found."
      end
    else
      @current_step = nil
    end
  end

  def current_step_index
    if current_step
      find_step_index(current_step.name)
    else
      nil
    end
  end

  def step_enabled?(step_name)
    find_step_index(step_name) < current_step_index
  end

  def prev_step
    if (index = current_step_index) && index > 0
      metaclass.all_steps_by_name[possible_steps[index - 1]]
    else
      nil
    end
  end
  
  def next_step
    if index = current_step_index
      metaclass.all_steps_by_name[possible_steps[index + 1]]
    else
      metaclass.all_steps_by_name[possible_steps[0]]
    end
  end
end
