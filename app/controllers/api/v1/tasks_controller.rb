class Api::V1::TasksController < ApplicationController
  before_action :authenticate_with_token!

  def index
    render json: { tasks: current_company.tasks.where("private = ? OR user_id = ?", false, current_user.id) }
  end

  def create
    task = current_user.tasks.build(task_params)
    if task.save
      render json: task, status: 201, location: [:api, current_user, task]
    else
      render json: { errors: task.errors }, status: 422
    end
  end

  def show
    task = current_company.tasks.find(params[:id])
    if !task.private || task.user_id == current_user.id
      render json: task
    else
      render json: { errors: "Not authenticated" }, status: :unauthorized
    end
  end

  def update
    task = current_user.tasks.find(params[:id])
    if task.update(task_params)
      render json: task, status: 200, location: [:api, current_user, task]
    else
      render json: { errors: task.errors }, status: 422
    end
  end

  def destroy
    task = current_user.tasks.find(params[:id])
    task.destroy
    head 204
  end

  private

    def task_params
      params.require(:task).permit(:title, :complete, :private, :user_id, :company_id)
    end
end
