class PaymentChargeModel {
    String object;
    int amount;
    int amount_refunded;
    Object application;
    Object application_fee;
    Object application_fee_amount;
    String balance_transaction;
    BillingDetails billing_details;
    String calculated_statement_descriptor;
    bool captured;
    int created;
    String currency;
    String customer;
    Object description;
    Object destination;
    Object dispute;
    bool disputed;
    Object failure_code;
    Object failure_message;
    List<Object> fraud_details;
    String id;
    Object invoice;
    bool livemode;
    List<Object> metadata;
    Object on_behalf_of;
    Object order;
    Outcome outcome;
    bool paid;
    Object payment_intent;
    String payment_method;
    PaymentMethodDetails payment_method_details;
    Object receipt_email;
    Object receipt_number;
    String receipt_url;
    bool refunded;
    Refunds refunds;
    Object review;
    Object shipping;
    Source source;
    Object source_transfer;
    Object statement_descriptor;
    Object statement_descriptor_suffix;
    String status;
    Object transfer_data;
    Object transfer_group;

    PaymentChargeModel({this.object, this.amount, this.amount_refunded, this.application, this.application_fee, this.application_fee_amount, this.balance_transaction, this.billing_details, this.calculated_statement_descriptor, this.captured, this.created, this.currency, this.customer, this.description, this.destination, this.dispute, this.disputed, this.failure_code, this.failure_message, this.fraud_details, this.id, this.invoice, this.livemode, this.metadata, this.on_behalf_of, this.order, this.outcome, this.paid, this.payment_intent, this.payment_method, this.payment_method_details, this.receipt_email, this.receipt_number, this.receipt_url, this.refunded, this.refunds, this.review, this.shipping, this.source, this.source_transfer, this.statement_descriptor, this.statement_descriptor_suffix, this.status, this.transfer_data, this.transfer_group});

    factory PaymentChargeModel.fromJson(Map<String, dynamic> json) {
        return PaymentChargeModel(
            object: json['object'],
            amount: json['amount'],
            amount_refunded: json['amount_refunded'],
            application: json['application'] != null,
            application_fee: json['application_fee'],
            application_fee_amount: json['application_fee_amount'],
            balance_transaction: json['balance_transaction'],
            //billing_details: json['billing_details'],
            calculated_statement_descriptor: json['calculated_statement_descriptor'],
            captured: json['captured'],
            created: json['created'],
            currency: json['currency'],
            customer: json['customer'],
            description: json['description'],
            destination: json['destination'],
            dispute: json['dispute'],
            disputed: json['disputed'],
            failure_code: json['failure_code'],
            failure_message: json['failure_message'],
            fraud_details: json['fraud_details'],
            id: json['id'],
            invoice: json['invoice'],
            livemode: json['livemode'],
            metadata: json['metadata'],
            on_behalf_of: json['on_behalf_of'],
            order: json['order'],
            outcome: json['outcome'] != null ? Outcome.fromJson(json['outcome']) : null,
            paid: json['paid'],
            payment_intent: json['payment_intent'],
            payment_method: json['payment_method'],
            //payment_method_details: json['payment_method_details'],
            receipt_email: json['receipt_email'],
            receipt_number: json['receipt_number'],
            receipt_url: json['receipt_url'],
            refunded: json['refunded'],
            refunds: json['refunds'] != null ? Refunds.fromJson(json['refunds']) : null,
            review: json['review'],
            shipping: json['shipping'],
            source: json['source'] != null ? Source.fromJson(json['source']) : null,
            source_transfer: json['source_transfer'],
            statement_descriptor: json['statement_descriptor'],
            statement_descriptor_suffix: json['statement_descriptor_suffix'],
            status: json['status'],
            transfer_data: json['transfer_data'],
            transfer_group: json['transfer_group'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['object'] = this.object;
        data['amount'] = this.amount;
        data['amount_refunded'] = this.amount_refunded;
        data['balance_transaction'] = this.balance_transaction;
        data['calculated_statement_descriptor'] = this.calculated_statement_descriptor;
        data['captured'] = this.captured;
        data['created'] = this.created;
        data['currency'] = this.currency;
        data['customer'] = this.customer;
        data['disputed'] = this.disputed;
        data['id'] = this.id;
        data['livemode'] = this.livemode;
        data['paid'] = this.paid;
        data['payment_method'] = this.payment_method;
        data['receipt_url'] = this.receipt_url;
        data['refunded'] = this.refunded;
        data['status'] = this.status;
        data['application'] = this.application;
        data['application_fee'] = this.application_fee;
        data['description'] = this.description;
        data['destination'] = this.destination;
        data['dispute'] = this.dispute;
        data['dispute'] = this.dispute;
        if (this.payment_method_details != null) {
            data['payment_method_details'] = this.payment_method_details.toJson();
        }
        return data;
    }
}

class Refunds {
    List<Object> data;
    String object;
    bool has_more;
    int total_count;
    String url;

    Refunds({this.data, this.object, this.has_more, this.total_count, this.url});

    factory Refunds.fromJson(Map<String, dynamic> json) {
        return Refunds(
            data: json['data'],
            object: json['object'],
            has_more: json['has_more'],
            total_count: json['total_count'],
            url: json['url'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['object'] = this.object;
        data['has_more'] = this.has_more;
        data['total_count'] = this.total_count;
        data['url'] = this.url;
        data['data'] = this.data;
        return data;
    }
}

class Source {
    String object;
    String address_city;
    String address_country;
    String address_line1;
    String address_line1_check;
    String address_line2;
    String address_state;
    String address_zip;
    String address_zip_check;
    String brand;
    String country;
    String customer;
    String cvc_check;
    Object dynamic_last4;
    int exp_month;
    int exp_year;
    String fingerprint;
    String funding;
    String id;
    String last4;
    List<Object> metadata;
    String name;
    Object tokenization_method;

    Source({this.object, this.address_city, this.address_country, this.address_line1, this.address_line1_check, this.address_line2, this.address_state, this.address_zip, this.address_zip_check, this.brand, this.country, this.customer, this.cvc_check, this.dynamic_last4, this.exp_month, this.exp_year, this.fingerprint, this.funding, this.id, this.last4, this.metadata, this.name, this.tokenization_method});

    factory Source.fromJson(Map<String, dynamic> json) {
        return Source(
            object: json['object'],
            address_city: json['address_city'],
            address_country: json['address_country'],
            address_line1: json['address_line1'],
            address_line1_check: json['address_line1_check'],
            address_line2: json['address_line2'],
            address_state: json['address_state'],
            address_zip: json['address_zip'],
            address_zip_check: json['address_zip_check'],
            brand: json['brand'],
            country: json['country'],
            customer: json['customer'],
            cvc_check: json['cvc_check'],
            dynamic_last4: json['dynamic_last4'],
            exp_month: json['exp_month'],
            exp_year: json['exp_year'],
            fingerprint: json['fingerprint'],
            funding: json['funding'],
            id: json['id'],
            last4: json['last4'],
            metadata: json['metadata'],
            name: json['name'],
            tokenization_method: json['tokenization_method'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['object'] = this.object;
        data['address_city'] = this.address_city;
        data['address_country'] = this.address_country;
        data['address_line1'] = this.address_line1;
        data['address_line1_check'] = this.address_line1_check;
        data['address_line2'] = this.address_line2;
        data['address_state'] = this.address_state;
        data['address_zip'] = this.address_zip;
        data['address_zip_check'] = this.address_zip_check;
        data['brand'] = this.brand;
        data['country'] = this.country;
        data['customer'] = this.customer;
        data['cvc_check'] = this.cvc_check;
        data['exp_month'] = this.exp_month;
        data['exp_year'] = this.exp_year;
        data['fingerprint'] = this.fingerprint;
        data['funding'] = this.funding;
        data['id'] = this.id;
        data['last4'] = this.last4;
        data['name'] = this.name;
        data['dynamic_last4'] = this.dynamic_last4;
        data['metadata'] = this.metadata;
        data['tokenization_method'] = this.tokenization_method;
        return data;
    }
}

class BillingDetails {
    Address address;
    Object email;
    String name;
    Object phone;

    BillingDetails({this.address, this.email, this.name, this.phone});

    factory BillingDetails.fromJson(Map<String, dynamic> json) {
        return BillingDetails(
            address: json['address'] != null ? Address.fromJson(json['address']) : null,
            email: json['email'],
            name: json['name'],
            phone: json['phone'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['name'] = this.name;
        data['email'] = this.email;
        data['phone'] = this.phone;
        return data;
    }
}

class Address {
    String city;
    String country;
    String line1;
    String line2;
    String postal_code;
    String state;

    Address({this.city, this.country, this.line1, this.line2, this.postal_code, this.state});

    factory Address.fromJson(Map<String, dynamic> json) {
        return Address(
            city: json['city'],
            country: json['country'],
            line1: json['line1'],
            line2: json['line2'],
            postal_code: json['postal_code'],
            state: json['state'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['city'] = this.city;
        data['country'] = this.country;
        data['line1'] = this.line1;
        data['line2'] = this.line2;
        data['postal_code'] = this.postal_code;
        data['state'] = this.state;
        return data;
    }
}

class Outcome {
    String network_status;
    Object reason;
    String risk_level;
    int risk_score;
    String seller_message;
    String type;

    Outcome({this.network_status, this.reason, this.risk_level, this.risk_score, this.seller_message, this.type});

    factory Outcome.fromJson(Map<String, dynamic> json) {
        return Outcome(
            network_status: json['network_status'],
            reason: json['reason'],
            risk_level: json['risk_level'],
            risk_score: json['risk_score'],
            seller_message: json['seller_message'],
            type: json['type'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['network_status'] = this.network_status;
        data['risk_level'] = this.risk_level;
        data['risk_score'] = this.risk_score;
        data['seller_message'] = this.seller_message;
        data['type'] = this.type;
        if (this.reason != null) {
            data['reason'] = this.reason;
        }
        return data;
    }
}

class PaymentMethodDetails {
    Card card;
    String type;

    PaymentMethodDetails({this.card, this.type});

    factory PaymentMethodDetails.fromJson(Map<String, dynamic> json) {
        return PaymentMethodDetails(
            card: json['card'] != null ? Card.fromJson(json['card']) : null,
            type: json['type'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['type'] = this.type;
        if (this.card != null) {
            data['card'] = this.card.toJson();
        }
        return data;
    }
}

class Card {
    String brand;
    Checks checks;
    String country;
    int exp_month;
    int exp_year;
    String fingerprint;
    String funding;
    Object installments;
    String last4;
    String network;
    Object three_d_secure;
    Object wallet;

    Card({this.brand, this.checks, this.country, this.exp_month, this.exp_year, this.fingerprint, this.funding, this.installments, this.last4, this.network, this.three_d_secure, this.wallet});

    factory Card.fromJson(Map<String, dynamic> json) {
        return Card(
            brand: json['brand'],
            checks: json['checks'] != null ? Checks.fromJson(json['checks']) : null,
            country: json['country'],
            exp_month: json['exp_month'],
            exp_year: json['exp_year'],
            fingerprint: json['fingerprint'],
            funding: json['funding'],
            installments: json['installments'],
            last4: json['last4'],
            network: json['network'],
            three_d_secure: json['three_d_secure'],
            wallet: json['wallet'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['brand'] = this.brand;
        data['country'] = this.country;
        data['exp_month'] = this.exp_month;
        data['exp_year'] = this.exp_year;
        data['fingerprint'] = this.fingerprint;
        data['funding'] = this.funding;
        data['last4'] = this.last4;
        data['network'] = this.network;
        if (this.checks != null) {
            data['checks'] = this.checks.toJson();
        }
        if (this.installments != null) {
            data['installments'] = this.installments;
        }
        if (this.three_d_secure != null) {
            data['three_d_secure'] = this.three_d_secure;
        }
        if (this.wallet != null) {
            data['wallet'] = this.wallet;
        }
        return data;
    }
}

class Checks {
    String address_line1_check;
    String address_postal_code_check;
    String cvc_check;

    Checks({this.address_line1_check, this.address_postal_code_check, this.cvc_check});

    factory Checks.fromJson(Map<String, dynamic> json) {
        return Checks(
            address_line1_check: json['address_line1_check'],
            address_postal_code_check: json['address_postal_code_check'],
            cvc_check: json['cvc_check'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['address_line1_check'] = this.address_line1_check;
        data['address_postal_code_check'] = this.address_postal_code_check;
        data['cvc_check'] = this.cvc_check;
        return data;
    }
}