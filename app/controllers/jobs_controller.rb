class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  before_action :validate_search_key, only: [:search]

  def index

    @jobs = case params[:order]
            when 'by_lower_bound'
              Job.published.order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 7)
            when 'by_upper_bound'
              Job.published.order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 7)
            else
              Job.published.recent.paginate(:page => params[:page], :per_page => 7)
            end
  end

  def show
    @job = Job.find(params[:id])

    if @job.is_hidden
      flash[:warning] = "This Job already archived"
      redirect_to root_path
    end
  end

  def edit
    @job = Job.find(params[:id])
    @categories = Category.all.map { |c| [c.name, c.id] }
  end

  def new
    @job = Job.new
    @categories = Category.all.map { |c| [c.name, c.id] }
  end

  def create
    @job = Job.new(job_params)
    @job.category_id = params[:category_id]
    if @job.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    @job = Job.find(params[:id])
    @job.category_id = params[:category_id]
    if @job.update(job_params)
      redirect_to jobs_path, notice: "Update Success!"
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    flash[:alert] = "Job deleted!"
    redirect_to jobs_path
  end

  def developer
    @jobs = Job.published.where(:category_id => "IT行业").recent.paginate(:page => params[:page], :per_page => 5)
  end

  def healthcare
    @jobs =  Job.published.where(:category => "医疗健康").recent.paginate(:page => params[:page], :per_page => 5)
  end

  def customer_service
    @jobs = Job.published.where(:category => "服务行业").recent.paginate(:page => params[:page], :per_page => 5)
  end

  def sales_marketing
    @jobs = Job.published.where(:category => "市场营销").recent.paginate(:page => params[:page], :per_page => 5)
  end

  def legal
    @jobs = Job.published.where(:category => "法律").recent.paginate(:page => params[:page], :per_page => 5)
  end

  def non_profit
    @jobs = Job.published.where(:category => "公益事业").recent.paginate(:page => params[:page], :per_page => 5)
  end

  def human_resource
    @jobs = Job.published.where(:category => "人力资源").recent.paginate(:page => params[:page], :per_page => 5)
  end

  def design
    @jobs = Job.published.where(:category => "设计").recent.paginate(:page => params[:page], :per_page => 5)
  end


  def search
      if @query_string.present?
        search_result = Job.published.ransack(@search_criteria).result(:distinct => true)
        @jobs = search_result.paginate(:page => params[:page], :per_page => 5 )
      end
    end

    protected

 def validate_search_key
   @query_string = params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
   @search_criteria = search_criteria(@query_string)
 end


 def search_criteria(query_string)
   { :title_cont => query_string }
 end


  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden, :job_location, :category_id_id)
  end



end
