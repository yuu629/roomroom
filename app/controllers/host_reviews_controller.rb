class HostReviewsController < ApplicationController
  def create
      
    # ステップ　1: 予約が存在するかどうかを確認します（room_id、guest_id、host_id）  
    # ステップ 2: 現在のホストがこの予約のゲストをすでにレビューしているかどうかを確認します。

    @reservation = Reservation.where(
                    id: host_review_params[:reservation_id],
                    room_id: host_review_params[:room_id],
                    user_id: host_review_params[:guest_id]
                   ).first

    if !@reservation.nil?

      @has_reviewed = HostReview.where(
                        reservation_id: @reservation.id,
                        guest_id: host_review_params[:guest_id]
                      ).first

      if @has_reviewed.nil?
          # レビューを許可
          @host_review = current_user.host_reviews.create(host_review_params)
          flash[:success] = "レビューを作成しました。"
      else
          # レビュー済み
          flash[:success] = "この予約はレビュー済みです。"
      end
    else
      flash[:alert] = "予約がありません。"
    end

    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @host_review = Review.find(params[:id])
    @host_review.destroy

    redirect_back(fallback_location: request.referer, notice: "削除しました。")
  end

  private
    def host_review_params
      params.require(:host_review).permit(:review, :stars, :room_id, :reservation_id, :guest_id)
    end
end
