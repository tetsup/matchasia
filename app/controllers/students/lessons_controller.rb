class Students::LessonsController < ApplicationController
  before_action :authenticate_student!

  def index
    @lessons = Lesson.eager_load(:reservation).preload(:teacher).from_now.sorted
  end
end
