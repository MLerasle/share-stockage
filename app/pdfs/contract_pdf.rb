class ContractPdf < Prawn::Document
  def initialize(advert, reservation, view)
    super(top_margin: 30)
    @advert = advert
    @reservation = reservation
    @view = view
    title
    people_informations
    details
    conditions
    footer
    start_new_page
    inventory_title
    inventory_table
    state_table
  end
  
  def title
    text "À conserver pendant 1 an", align: :right, size: 8
    text "CONTRAT DE LOCATION", align: :center, style: :bold, size: 14
  end
  
  def people_informations
    move_down 20
    stroke do
      horizontal_rule
      move_down 10
      vertical_line 560, 660, at: 270
    end
    
    bounding_box([0, 660], width: 240, height: 100) do
      transparent(0) { stroke_bounds }
      text "LOCATAIRE", style: :bold, align: :center
      move_down 15
      text "Nom :", style: :bold, size: 10
      move_down 5
      text "Tél : ", style: :bold, size: 10
      move_down 5
      text "Adresse :", style: :bold, size: 10
    end
    
    bounding_box([300, 660], width: 240, height: 100) do
      transparent(0) { stroke_bounds }
      text "PROPRIETAIRE", style: :bold, align: :center
      move_down 15
      text "Nom :", style: :bold, size: 10
      move_down 5
      text "Tél : ", style: :bold, size: 10
      move_down 5
      text "Adresse :", style: :bold, size: 10
    end
  end
  
  def details
    move_down 20
    stroke do
      horizontal_rule
      move_down 15
      vertical_line 420, 490, at: 270
    end
    text "Caractéristiques de la location", style: :bold, align: :center
    
    bounding_box([0, 490], width: 240, height: 70) do
      transparent(0) { stroke_bounds }
      text "<strong>Superficie :</strong> #{@advert.area} m²", size: 10, inline_format: true
      move_down 5
      text "<strong>Conditions d'accès :</strong> #{@advert.access_type_hr}", size: 10, inline_format: true
      move_down 5
      text "<strong>Adresse :</strong> #{@advert.address}", size: 10, inline_format: true
    end
    
    bounding_box([300, 490], width: 240, height: 70) do
      transparent(0) { stroke_bounds }
      text "<strong>Début de la location :</strong> #{@reservation.start_date}", size: 10, inline_format: true
      move_down 5
      text "<strong>Fin de la location :</strong> #{@reservation.end_date}", size: 10, inline_format: true
      move_down 5
      text "<strong>Prix :</strong> CHF #{@reservation.price}", size: 10, inline_format: true
    end
  end
  
  def conditions
    move_down 15
    stroke do
      horizontal_rule
      move_down 25
    end
    text "Conditions:", style: :bold, size: 10
    move_down 10
    text "- Les deux parties au contrat doivent être âgés d'au moins 18 ans.", size: 10
    move_down 5
    text "- Les matériaux dangereux, toxiques, illicites, périssables et les organismes vivants sont interdits.", size: 10
    move_down 5
    text "- N'oubliez pas de vérifier l'identité de votre interlocuteur.", size: 10
  end
  
  def footer
    move_down 20
    stroke do
      horizontal_rule
      move_down 25
    end
    text "Je soussigné(e), .........................................., ai examiné attentivement l’état de l’espace et confirme qu’il est fidèlement décrit ci-dessus. Je prends la responsabilité de cet espace et m’engage à le restituer dans l’état initial, à la date indiquée sur ce contrat. J’autorise irrévocablement Share Stockage à prélever sur ma carte bancaire toute somme due au propriétaire au titre du contrat de location, dont les clauses détaillées figurent sur la page #, et toute somme due à Share Stockage au titre des conditions générales du site.", size: 8
    move_down 15
    bounding_box([0, 200], width: 240, height: 20) do
      transparent(0) { stroke_bounds }
      text "Signature du locataire :", style: :bold, size: 10
    end
    bounding_box([300, 200], width: 240, height: 20) do
      transparent(0) { stroke_bounds }
      text "Signature du propriétaire :", style: :bold, size: 10
    end
  end
  
  def inventory_title
    text "À conserver pendant 1 an", align: :right, size: 8
    text "Inventaire", align: :center, style: :bold, size: 14
  end
  
  def inventory_table
    move_down 20
    stroke do
      horizontal_rule
      move_down 20
    end
    data = [["Objet", "Quantité", "Etat"]]
    data += [["", "", ""]] * 15
    table(data, width: 540) do
      row(0).align = :center
      1.upto(15) do |i|
        row(i).height = 25
      end
    end
  end
  
  def state_table
    move_down 30
    text "Etat des lieux", style: :bold, align: :center
    move_down 20
    data = [["", "Mauvais", "Moyen", "Bon", "Commentaires"], ["Porte", "", "", "", ""], ["Sol", "", "", "", ""], ["Murs", "", "", "", ""], ["Autres", "", "", "", ""]]
    table(data, width: 540) do
      row(0).align = :center
      column(0).align = :center
    end
  end
end