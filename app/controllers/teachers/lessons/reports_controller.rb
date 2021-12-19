class Teachers::Lessons::ReportsController < ApplicationController
  before_action :authenticate_teacher!
  before_action :fetch_lesson

  def new
    @report = Report.new
    render :edit
  end

  def edit
    @report = @lesson.report
  end

  def create
    @report = current_teacher.reports.build({ lesson_id: params[:lesson_id] }.merge(report_params))
    if @report.save
      redirect_to teachers_lessons_path, notice: 'レポートを保存しました'
    else
      render :edit
    end
  end

  private

  def fetch_lesson
    @lesson = current_teacher.lessons.find(params[:lesson_id])
  end

  def report_params
    params.require(:report).permit(:content)
  end
end
