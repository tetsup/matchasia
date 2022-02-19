class Teachers::Lessons::FeedbacksController < ApplicationController
  before_action :authenticate_teacher!
  before_action :fetch_lesson

  def new
    @feedback = Feedback.new
    render :edit
  end

  def edit
    @feedback = @lesson.feedback
  end

  def create
    @feedback = current_teacher.feedbacks.build({ lesson_id: params[:lesson_id] }.merge(feedback_params))
    if @feedback.save
      StudentMailer.feedback(@feedback).deliver_later
      redirect_to teachers_lessons_path, notice: 'フィードバックを保存しました'
    else
      render :edit
    end
  end

  private

  def fetch_lesson
    @lesson = current_teacher.lessons.find(params[:lesson_id])
  end

  def feedback_params
    params.require(:feedback).permit(:content)
  end
end
