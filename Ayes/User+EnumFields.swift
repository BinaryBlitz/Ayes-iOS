//
//  User+EnumFields.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 25/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

extension User {
  
  //MARK: - Sex
  
  enum Sex: String, QuestionnaireItem {
    case Male = "male"
    case Female = "female"
    
    static var optionsList: [String] {
      return [Male.rawValue, Female.rawValue]
    }
  }
  
  //MARK: - Occupation
  
  enum Occupation: String, QuestionnaireItem {
    case Businessman = "businessman"
    case TopManager = "top_manager"
    case MiddleManager = "middle_manager"
    case Engineer = "engineer"
    case Worker = "worker"
    case Gos = "civil_servant"
    case Student = "student"
    case Pensioner = "pensioner"
    case Unemployed = "unemployed"
    
    static var optionsList: [String] {
      return [Businessman.rawValue, TopManager.rawValue, MiddleManager.rawValue,
          Engineer.rawValue, Worker.rawValue, Gos.rawValue, Student.rawValue,
          Pensioner.rawValue, Unemployed.rawValue]
    }
  }
  
  //MARK: - Income
  
  enum Income: String, QuestionnaireItem {
    case None = "none"
    case less10 = "over0"
    case from10to30 = "over10000"
    case from30to60 = "over30000"
    case from60to80 = "over60000"
    case from80to100 = "over80000"
    case from100to130 = "over100000"
    case from130to160 = "over130000"
    case more160 = "over160000"
    
    static var optionsList: [String] {
      return [None.rawValue, less10.rawValue, from10to30.rawValue, from30to60.rawValue,
          from60to80.rawValue, from80to100.rawValue, from100to130.rawValue,
          from130to160.rawValue, more160.rawValue]
    }
  }
  
  //MARK: - Education
  
  enum Education: String, QuestionnaireItem {
    case LowerSecondary = "lower_secondary"
    case UpperSecondary = "upper_secondary"
    case IncompleteHigher = "incomplete_higher"
    case Higher = "higher"
    case College = "vocational"
    case Academic = "academic"
    
    static var optionsList: [String] {
      return [LowerSecondary.rawValue, UpperSecondary.rawValue, College.rawValue,
        IncompleteHigher.rawValue, Higher.rawValue, Academic.rawValue]
    }
  }
  
  //MARK: - Relationship
  
  enum Relationship: String, QuestionnaireItem {
    case Maried = "married"
    case NotMaried = "single"
    case Divorced = "divorced"
    case CivilUnion = "civil_union"
    case Widow = "widow"
    
    static var optionsList: [String] {
      return [Maried.rawValue, NotMaried.rawValue, Divorced.rawValue,
       CivilUnion.rawValue, Widow.rawValue]
    }
  }
  
  //MARK: - Locality
  
  enum Locality: String, QuestionnaireItem {
    case Village = "village"
    case UrbanVillage = "urban_village"
    case Town = "town"
    case City = "city"
    case MillionCity = "million_city"
    
    static var optionsList: [String] {
      return [Village.rawValue, UrbanVillage.rawValue, Town.rawValue,
            City.rawValue, MillionCity.rawValue]
    }
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
}