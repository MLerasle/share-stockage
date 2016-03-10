class UserMailer < ActionMailer::Base
  default from: ENV["contact_email"]

  def new_advert_mail(advert)
    @advert = advert
    mail(to: "admin@sharestockage.ch", subject: "Nouvelle annonce sur le site")
  end
  
  def validate_reservation(receiver, reservation)
    @receiver = receiver
    @reservation = reservation
    @advert = @reservation.advert
    contract = ContractPdf.new(@advert, @reservation, view_context)
    attachments["contrat.pdf"] = { mime_type: 'application/pdf', content: contract.render }
    mail(to: @receiver.email, subject: "Votre réservation pour #{@advert.title} a été validée")
  end

  def validate_reservation_owner(receiver, reservation)
    @receiver = receiver
    @advert = reservation.advert
    contract = ContractPdf.new(@advert, reservation, view_context)
    attachments["contrat.pdf"] = { mime_type: 'application/pdf', content: contract.render }
    mail(to: @receiver.email, subject: "La réservation pour #{@advert.title} a été validée")
  end

  def validate_advert(receiver, advert)
    @advert = advert
    @receiver = receiver
    mail(to: @receiver.email, subject: "Votre annonce #{@advert.title} est en ligne")
  end

  # def reservation_feedback(advert, reservation_user)
  #   @advert = advert
  #   @reservation_user = reservation_user
  #   @advert_url = "http://sharestockage.ch/garde-meuble/#{@advert.id}"
  #   @gift_url = "http://sharestockage.ch/charges/new"
  #   mail(to: @reservation_user.email, subject: "Votre avis nous importe!")
  # end
  #
  # def advert_feedback(user)
  #   @user = user
  #   @gift_url = "http://sharestockage.ch/charges/new"
  #   mail(to: @user.email, subject: "Votre avis nous importe!")
  # end

  def notify_user(user, body, subject, sender)
    @user = user
    @body = body
    @sender = sender
    @url = "http://sharestockage.ch/mon-compte/sign_in"
    mail(to: @user.email, subject: subject)
  end

  def pending_reservation(reservation)
    @user = reservation.user
    @advert = reservation.advert
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
    @url = "http://sharestockage.ch/mon-compte/sign_in"
    mail(to: @owner.email, subject: "Demande de réservation de votre espace de stockage")
  end
  
  def payment_default(reservation)
    @user = reservation.user
    @advert = reservation.advert
    @url = "http://sharestockage.ch/mon-compte/lodger_space"
    mail(to: @user.email, subject: "Carte bancaire refusée")
  end
end
