// import Principal "mo:base/Principal";
// import Debug "mo:base/Debug";
// import Cycles "mo:base/ExperimentalCycles";
// import HashMap "mo:base/HashMap";
// import List "mo:base/List";
// import Iter "mo:base/Iter";
// import Map "mo:base/HashMap";
// import Text "mo:base/Text";
// import Bool "mo:base/Bool";
// import Error "mo:base/Error";
// import Option "mo:base/Option";
// import Time "mo:base/Time";
// import Array "mo:base/Array";
// import Int "mo:base/Int";
// import Buffer "mo:base/Buffer";
// import Nat64 "mo:base/Nat64";
// import Nat "mo:base/Nat";
// import Blob "mo:base/Blob";
// import Float "mo:base/Float";
// import ExperimentalStableMemory "mo:base/ExperimentalStableMemory";
// import StableMemory "mo:base/ExperimentalStableMemory";

// actor KYC_Canister {

//     // Define the data structure for customer information
//     type Customer = {
//         id : Text;
//         name : Text;
//         phone : Text;
//         identityNumber : Text;
//         identityDoc : Blob;
//         verified : Bool;
//     };

//     private stable var mapEntries : [(Text, Customer)] = [];
//     var map = HashMap.HashMap<Text, Customer>(0, Text.equal, Text.hash);

//     // Storage for customer data
//     stable var customers : [Customer] = [];

//     // Function to add a new customer
//     public func addCustomer(id : Text, name : Text, phone : Text, identityNumber : Text, identityDoc : Blob) : async Text {
//         let newCustomer : Customer = {
//             id = id;
//             name = name;
//             phone = phone;
//             identityNumber = identityNumber;
//             identityDoc = identityDoc;
//             verified = false;
//         };
//         map.put(id, newCustomer);
//         return "Customer added successfully.";
//     };

//     // Function to verify a customer
//     public func verifyCustomer(id : Text) : async Text {
//         switch (map.get(id)) {
//             case (null) {
//                 return "User profile doesnot exists";
//             };
//             case (?value) {
//                 let updatedProfile = {
//                     value with
//                     verified = true;
//                 };
//                 let updatedMap = map.replace(id, updatedProfile);
//                 return "updated";
//             };
//         };
//     };

//     // Function to retrieve a customer's information
//     public query func getCustomer(id : Text) : async ?Customer {
//         return map.get(id);
//     };

//     // Debugging: Function to list all customers (not recommended for production use)
//     public query func listCustomers(id : Text) : async [Customer] {
//         let ids = Iter.toArray(map.vals());
//         return ids;
//     };
// };

import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Cycles "mo:base/ExperimentalCycles";
import HashMap "mo:base/HashMap";
import List "mo:base/List";
import Iter "mo:base/Iter";
import Map "mo:base/HashMap";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Error "mo:base/Error";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Buffer "mo:base/Buffer";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Blob "mo:base/Blob";
import Float "mo:base/Float";
import ExperimentalStableMemory "mo:base/ExperimentalStableMemory";
import StableMemory "mo:base/ExperimentalStableMemory";

actor KYC_Canister {

    type Customer = {
        id : Text;
        family_name : Text;
        given_name : Text;
        birth_date : Text; // ISO format
        age_over_18 : Bool;
        role:Text;
        // Optional fields
        age_over_NN : ?Bool;
        age_in_years : ?Nat;
        age_birth_year : ?Nat;
        family_name_birth : ?Text;
        given_name_birth : ?Text;
        birth_place : ?Text;
        birth_country : ?Text;
        birth_state : ?Text;
        birth_city : ?Text;
        resident_address : ?Text;
        resident_country : ?Text;
        resident_state : ?Text;
        resident_city : ?Text;
        resident_postal_code : ?Text;
        resident_street : ?Text;
        gender : ?Nat; // 0, 1, 2 for unspecified, male, female
        nationality : ?Text; // ISO Alpha-2 code
        issuance_date : ?Text; // ISO format
        expiry_date : ?Text; // ISO format
        issuing_authority : ?Text;
        document_number : ?Text;
        issuing_country : ?Text;
        issuing_jurisdiction : ?Text;
        phone : Text;
        identityNumber : Text;
        identityDoc : Blob;
        verified : Bool;
    };

    private stable var mapEntries : [(Text, Customer)] = [];
    var map = HashMap.HashMap<Text, Customer>(0, Text.equal, Text.hash);

    // Storage for customer data
    // stable var customers : [Customer] = [];

    // Function to add a new customer
    public func addCustomer(newCustomer : Customer) : async Text {

        map.put(newCustomer.id, newCustomer);
        return "Customer added successfully.";
    };

    // Function to verify a customer
    public func verifyCustomer(id : Text) : async Text {
        switch (map.get(id)) {
            case (null) {
                return "User profile does not exist";
            };
            case (?value) {
                let updatedProfile = {
                    value with
                    verified = true;
                };
                map.put(id, updatedProfile);
                return "Profile updated";
            };
        };
    };

    // Function to retrieve a customer's information
    public query func getCustomer(id : Text) : async ?Customer {
        return map.get(id);
    };

    // Debugging: Function to list all customers (not recommended for production use)
    public query func listCustomers() : async [Customer] {
        let ids = Iter.toArray(map.vals());
        return ids;
    };
};
