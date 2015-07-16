class UserMailer < ActionMailer::Base
  default from: ENV["contact_email"]
  
  def validate_reservation(receiver, reservation)
    @receiver = receiver
    @advert = reservation.advert
    contract = ContractPdf.new(@advert, reservation, view_context)
    attachments["contrat.pdf"] = { mime_type: 'application/pdf', content: contract.render }
    @advert_url = "http://localhost:8080/adverts/#{@advert.id}"
    mail(to: @receiver.email, subject: "Share Stockage - Votre réservation pour #{@advert.title} a été validée")
  end

  def reservation_feedback(advert, reservation_user)
    @advert = advert
    @reservation_user = reservation_user
    @advert_url = "http://localhost:8080/adverts/#{@advert.id}"
    @gift_url = "http://localhost:8080/charges/new"
    mail(to: @reservation_user.email, subject: "Votre avis nous importe!")
  end

  def advert_feedback(user)
    @user = user
    @gift_url = "http://localhost:8080/charges/new"
    mail(to: @user.email, subject: "Votre avis nous importe!")
  end

  def notify_user(user)
    @user = user
    @url = "http://localhost:8080/users/sign_in"
    mail(to: @user.email, subject: "Vous avez reçu un nouveau message sur Share Stockage")
  end
end
