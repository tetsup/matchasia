class Teachers::StudentsController < ApplicationController
  before_action :authenticate_teacher!

  def show
    @student = Student.find(params[:id])
    @reservations = @student.reservations.includes(lesson: :teacher).includes(lesson: :report).sorted
  end
end
