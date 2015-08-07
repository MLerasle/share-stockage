class UserMailer < ActionMailer::Base
  default from: ENV["contact_email"]
  
  def validate_reservation(receiver, reservation)
    @receiver = receiver
    @reservation = reservation
    @advert = @reservation.advert
    contract = ContractPdf.new(@advert, @reservation, view_context)
    attachments["contrat.pdf"] = { mime_type: 'application/pdf', content: contract.render }
    @advert_url = "http://sharestockage.ch/adverts/#{@advert.id}"
    mail(to: @receiver.email, subject: "Votre réservation pour #{@advert.title} a été validée")
  end

  def validate_reservation_owner(receiver, reservation)
    @receiver = receiver
    @advert = reservation.advert
    contract = ContractPdf.new(@advert, reservation, view_context)
    attachments["contrat.pdf"] = { mime_type: 'application/pdf', content: contract.render }
    @advert_url = "http://sharestockage.ch/adverts/#{@advert.id}"
    mail(to: @receiver.email, subject: "La réservation pour #{@advert.title} a été validée")
  end

  # def reservation_feedback(advert, reservation_user)
  #   @advert = advert
  #   @reservation_user = reservation_user
  #   @advert_url = "http://sharestockage.ch/adverts/#{@advert.id}"
  #   @gift_url = "http://sharestockage.ch/charges/new"
  #   mail(to: @reservation_user.email, subject: "Votre avis nous importe!")
  # end
  #
  # def advert_feedback(user)
  #   @user = user
  #   @gift_url = "http://sharestockage.ch/charges/new"
  #   mail(to: @user.email, subject: "Votre avis nous importe!")
  # end

  def notify_user(user)
    @user = user
    @url = "http://sharestockage.ch/users/sign_in"
    mail(to: @user.email, subject: "Vous avez reçu un nouveau message sur Share Stockage")
  end

  def pending_reservation(reservation)
    @user = reservation.user
    @advert = reservation.advert
    @advert_url = "http://sharestockage.ch/adverts/#{@advert.id}"
    mail(to: @user.email, subject: "Merci pour votre demande de réservation")
  end

  def cancel_reservation(reservation)
    @user = reservation.user
    @advert = reservation.advert
    @reservation = reservation
    mail(to: @user.email, subject: "Votre réservation n'a pas pu aboutir")
  end

  def new_reservation(reservation)
    @advert = reservation.advert
    @owner = @advert.user
    @url = "http://sharestockage.ch/users/sign_in"
    mail(to: @owner.email, subject: "Demande de réservation de votre espace")
  end
end
