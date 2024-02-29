-- Tabelle Dokumenten-Informationen
-- Tabelle dropen
DROP TABLE IF EXISTS inf_documents;

-- Tabelle erstellen
CREATE TABLE IF NOT EXISTS inf_documents (
    doc_type   VARCHAR(3),                  -- Type des Dokuments   (Sparkasse(Spk),    Einkommen(Inc), Ausgaben(Exp),      Einlagen(Dsp))
    doc_name   VARCHAR(30),                 -- Deutsche Difinition  (Sparkasse,         Einkommen,      Ausgaben,           Einlegen)
    doc_tabl   VARCHAR(30),                 -- Dokuments-Tabelle    (doc_banks,         doc_incomes,    doc_expenditures,   doc_deposits)   ?expenses?
    doc_view   VARCHAR(30),                 -- Dokuments-Ansicht
    doc_form   VARCHAR(30),                 -- Dokuments-Formularname
    pos_tabl   VARCHAR(30),                 -- Positions-Tabelle
    pos_form   VARCHAR(30),                 -- Positions-Formularname
    rls_view   VARCHAR(30),                 -- Freigabe-Ansicht des Dokuments
    def_acc    INTEGER,                     -- Id von Standardkonto für den Dokument Sk - sparkasse (7), Rest - brieftasche (5) 
    doc_frq    INTEGER,                     -- Dokumenthäufigkeit (Frequency)
    CONSTRAINT pk_infd      PRIMARY KEY (doc_type),
    CONSTRAINT fk_infd_accd FOREIGN KEY (def_acc)
    REFERENCES cat_accounts (id)
);
