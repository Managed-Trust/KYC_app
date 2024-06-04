
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
        role : Text;
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

        switch (map.get(newCustomer.id)) {
            case (null) {
                if (newCustomer.role == "") {
                    return "Role cannot be empty.";
                };
                if (newCustomer.phone == "" or newCustomer.identityNumber == "") {
                    return "Phone number and identity number cannot be empty.";
                };
                map.put(newCustomer.id, newCustomer);
                return "Customer added successfully.";
            };
            case (?value) {

                return "Customer with this ID already exists.";

            };
        };

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

    // Function to set the role of a customer
    public shared (msg) func setRole(id : Text, setRole : Text) : async Text {
        switch (map.get(id)) {
            case (null) {
                return "User profile does not exist.";
            };
            case (?value) {
                if (setRole == "") {
                    return "Role cannot be empty.";
                };
                let updatedProfile = {
                    value with
                    role = setRole;
                };
                map.put(id, updatedProfile);
                return "Role updated.";
            };
        };
    };

    // Function to update customer information
    public func updateCustomer(id : Text, updatedCustomer : Customer) : async Text {
        switch (map.get(id)) {
            case (null) {
                return "User profile does not exist";
            };
            case (?value) {
                map.put(id, updatedCustomer);
                return "Customer updated successfully.";
            };
        };
    };

    // Function to delete a customer
    public func deleteCustomer(id : Text) : async Text {
        switch (map.get(id)) {
            case (null) {
                return "User profile does not exist";
            };
            case (?value) {
                map.delete(id);
                return "Customer deleted successfully.";
            };
        };
    };

    // // Function to send email to a customer (mock implementation)
    public func sendEmail(id : Text, subject : Text, body : Text) : async Text {
        switch (map.get(id)) {
            case (null) {
                return "User profile does not exist";
            };
            case (?value) {
                Debug.print("Sending email to " # id # " with subject: " # subject # " and body: " # body);
                return "Email sent successfully.";
            };
        };
    };

    // // Function to check if the customer is an admin
    public query func isAdmin(id : Text) : async Bool {
        switch (map.get(id)) {
            case (null) {
                return false;
            };
            case (?value) {
                return value.role == "Admin";
            };
        };
    };

    // // Function to check if the customer is a registered user
    public query func isRegisteredUser(id : Text) : async Bool {
        switch (map.get(id)) {
            case (null) {
                return false;
            };
            case (?value) {
                return value.role == "Registered User";
            };
        };
    };

    public query func getCustomersByRole(role : Text) : async [Customer] {
        let customers = Iter.filter<Customer>(
            map.vals(),
            func(customer) : Bool {
                customer.role == role;
            },
        );
        return Iter.toArray(customers);
    };

    // Function to check if a customer is verified
    public query func isVerified(id : Text) : async Bool {
        switch (map.get(id)) {
            case (null) {
                return false;
            };
            case (?value) {
                return value.verified;
            };
        };
    };

    // Function to get a list of verified customers
    public query func getVerifiedCustomers() : async [Customer] {
        let verifiedCustomers = Iter.filter<Customer>(
            map.vals(),
            func(customer) : Bool {
                customer.verified;
            },
        );
        return Iter.toArray(verifiedCustomers);
    };

    system func preupgrade() {
        mapEntries := Iter.toArray(map.entries());
    };
    system func postupgrade() {
        map := HashMap.fromIter<Text, Customer>(mapEntries.vals(), 1, Text.equal, Text.hash);
    };
};
