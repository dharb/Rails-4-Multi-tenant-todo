class Api::V1::CompaniesController < ApplicationController

  def create
    company = Company.new(company_params)
    if company.save
      render json: company, status: 201, location: [:api, company]
    else
      render json: { errors: company.errors }, status: 422
    end
  end

  def show
    render json: Company.find(params[:id])
  end

  def update
    company = Company.find(params[:id])
    if company.update(company_params)
      render json: company, status: 200, location: [:api, company]
    else
      render json: { errors: company.errors }, status: 422
    end
  end

  def destroy
    company = Company.find(params[:id])
    company.destroy
    head 204
  end

  private

  def company_params
    params.require(:company).permit(:name, :subdomain)
  end
end
