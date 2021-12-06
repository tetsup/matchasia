class TeachersController < ActionController::Base
  def show
    @teacher = Teacher.find(params[:id])
  end
end
