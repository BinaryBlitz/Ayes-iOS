//
//  User.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//
import SwiftyJSON

class User: NSObject, NSCoding {
  
  var birthDate: NSDate?
  var sex: Sex?
  
  var region: String?
  var locality: Locality?
  var occupation: Occupation?
  var income: Income?
  var education: Education?
  var relationship: Relationship?
  
  override init() {
    super.init()
  }
  
  func isAllFieldsFilled() -> Bool {
    return birthDate != nil && sex != nil && region != nil && occupation != nil &&
      income != nil && education != nil && relationship != nil
  }
  
  //MARK: - Regions
  
  enum Region: String, QuestionnaireItem {
    case AD
    case AL
    case ALT
    case AMU
    case ARK
    case AST
    case BA
    case BEL
    case BRY
    case BU
    case CE
    case CHE
    case CHU
    case CU
    case DA
    case IN
    case IRK
    case IVA
    case KAM
    case KB
    case KC
    case KDA
    case KEM
    case KGD
    case KGN
    case KHA
    case KHM
    case KIR
    case KK
    case KL
    case KLU
    case KO
    case KOS
    case KR
    case KRS
    case KYA
    case LEN
    case LIP
    case MAG
    case ME
    case MO
    case MOS
    case MOW
    case MUR
    case NEN
    case NGR
    case NIZ
    case NVS
    case OMS
    case ORE
    case ORL
    case PER
    case PNZ
    case PRI
    case PSK
    case ROS
    case RYA
    case SA
    case SAK
    case SAM
    case SAR
    case SE
    case SMO
    case SPE
    case STA
    case SVE
    case TA
    case TAM
    case TOM
    case TUL
    case TVE
    case TY
    case TYU
    case UD
    case ULY
    case VGG
    case VLA
    case VLG
    case VOR
    case YAN
    case YAR
    case YEV
    case ZAB
    
    static var optionsList: [String] {
    return [AD.rawValue, AL.rawValue, ALT.rawValue, AMU.rawValue, ARK.rawValue, AST.rawValue,
    BA.rawValue, BEL.rawValue, BRY.rawValue, BU.rawValue, CE.rawValue, CHE.rawValue, CHU.rawValue,
    CU.rawValue, DA.rawValue, IN.rawValue, IRK.rawValue, IVA.rawValue, KAM.rawValue, KB.rawValue, KC.rawValue,
    KDA.rawValue, KEM.rawValue, KGD.rawValue, KGN.rawValue, KHA.rawValue, KHM.rawValue, KIR.rawValue, KK.rawValue,
    KL.rawValue, KLU.rawValue, KO.rawValue, KOS.rawValue, KR.rawValue, KRS.rawValue, KYA.rawValue, LEN.rawValue, LIP.rawValue,
    MAG.rawValue, ME.rawValue, MO.rawValue, MOS.rawValue, MOW.rawValue, MUR.rawValue, NEN.rawValue, NGR.rawValue, NIZ.rawValue, NVS.rawValue,
    OMS.rawValue, ORE.rawValue, ORL.rawValue, PER.rawValue, PNZ.rawValue, PRI.rawValue, PSK.rawValue, ROS.rawValue,
    RYA.rawValue, SA.rawValue, SAK.rawValue, SAM.rawValue, SAR.rawValue, SE.rawValue, SMO.rawValue, SPE.rawValue,
    STA.rawValue, SVE.rawValue, TA.rawValue, TAM.rawValue, TOM.rawValue, TUL.rawValue, TVE.rawValue, TY.rawValue, TYU.rawValue,
    UD.rawValue, ULY.rawValue, VGG.rawValue, VLA.rawValue, VLG.rawValue, VOR.rawValue, YAN.rawValue, YAR.rawValue, YEV.rawValue,
    ZAB.rawValue].sort()
    }
  }
  
  //MARK: - NSCoding
  
  @objc required init(coder aDecoder: NSCoder) {
    birthDate = aDecoder.decodeObjectForKey(kBirthDate) as? NSDate
    if let rawSex = aDecoder.decodeObjectForKey(kSex) as? String {
      sex = Sex(rawValue: rawSex)
    }
    if let value = aDecoder.decodeObjectForKey(kRegion) as? String {
      region = value
    }
    if let rawLocality = aDecoder.decodeObjectForKey(kLocality) as? String {
      locality = Locality(rawValue: rawLocality)
    }
    if let rawOccupation = aDecoder.decodeObjectForKey(kOccupation) as? String {
      occupation = Occupation(rawValue: rawOccupation)
    }
    if let rawIncome = aDecoder.decodeObjectForKey(kIncome) as? String {
      income = Income(rawValue: rawIncome)
    }
    if let rawEducation = aDecoder.decodeObjectForKey(kEducation) as? String {
      education = Education(rawValue: rawEducation)
    }
    if let rawRelationship = aDecoder.decodeObjectForKey(kRelationship) as? String {
      relationship = Relationship(rawValue: rawRelationship)
    }
  }
  
  @objc func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(birthDate, forKey: kBirthDate)
    aCoder.encodeObject(sex?.rawValue, forKey: kSex)
    aCoder.encodeObject(region, forKey: kRegion)
    aCoder.encodeObject(locality?.rawValue, forKey: kLocality)
    aCoder.encodeObject(occupation?.rawValue, forKey: kOccupation)
    aCoder.encodeObject(income?.rawValue, forKey: kIncome)
    aCoder.encodeObject(education?.rawValue, forKey: kEducation)
    aCoder.encodeObject(relationship?.rawValue, forKey: kRelationship)
  }
}