class GuestReviewsController < ApplicationController
  def create
    # ステップ 1: 予約が存在するかどうかを確認します（room_id、host_id、host_id）
    # ステップ 2: 現在のホストがこの予約のゲストをすでにレビューしているかどうかを確認します。

    @reservation = Reservation.where(
                    id: guest_review_params[:reservation_id],
                    room_id: guest_review_params[:room_id]
                   ).first

    if !@reservation.nil? && @reservation.room.user.id == guest_review_params[:host_id].to_i

      @has_reviewed = GuestReview.where(
                        reservation_id: @reservation.id,
                        host_id: guest_review_params[:host_id]
                      ).first

      if @has_reviewed.nil?
          # レビューを許可
          @guest_review = current_user.guest_reviews.create(guest_review_params)
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
    @guest_review = Review.find(params[:id])
    @guest_review.destroy

    redirect_back(fallback_location: request.referer, notice: "削除しました。")
  end

  private
    def guest_review_params
      params.require(:guest_review).permit(:review, :stars, :room_id, :reservation_id, :host_id)
    end
end
