class Admins::TeachersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @teachers = Teacher.all
  end

  def destroy
    Teacher.find(params[:id]).destroy!
    redirect_to admins_teachers_path, notice: '削除しました'
  end

  def become
    sign_in(:teacher, Teacher.find(params[:id]))
    redirect_to root_path
  end
end
