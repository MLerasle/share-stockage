class UserMailer < ActionMailer::Base
  default from: ENV["contact_email"]
  
  # def prereservation_email(receiver, advert)
  #   @receiver = receiver
  #   @advert = advert
  #   @url = "http://localhost:8080/adverts/#{@advert.id}/edit"
  #   mail(to: @receiver.email, subject: "Sharing Space - Demande de réservation pour votre annonce #{@advert.title}")
  # end
  
  def validate_reservation(receiver, reservation)
    @receiver = receiver
    @advert = reservation.advert
    contract = ContractPdf.new(@advert, reservation, view_context)
    attachments["contrat.pdf"] = { mime_type: 'application/pdf', content: contract.render }
    @advert_url = "http://localhost:8080/adverts/#{@advert.id}"
    mail(to: @receiver.email, subject: "Sharing Space - Votre réservation pour #{@advert.title} a été validée")
  end
  
  def cancel_reservation(receiver, reservation)
    @receiver = receiver
    @advert = reservation.advert
    @url = "http://localhost:8080/users/#{@receiver.id}"
    mail(to: @receiver.email, subject: "Sharing Space - Refus de votre réservation pour #{@advert.title}")
  end
  
  def update_reservation(receiver, reservation)
    @receiver = receiver
    @advert = reservation.advert
    @url = "http://localhost:8080/users/#{@receiver.id}"
    mail(to: @receiver.email, subject: "Sharing Space - Modification d'une réservation concernant votre annonce #{@advert.title}")
  end
  
  # def contact_announcer(user, subject, body)
  #   @receiver = user
  #   @body = body
  #   mail(to: @receiver.email, subject: "Sharing Space - #{subject}")
  # end

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
end
