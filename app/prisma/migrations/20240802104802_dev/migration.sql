-- CreateTable
CREATE TABLE "Network" (
    "id" SERIAL NOT NULL,
    "display_name" TEXT,
    "internal_name" TEXT,
    "native_currency" TEXT,
    "is_testnet" BOOLEAN,
    "is_featured" BOOLEAN,
    "logo" TEXT,
    "chain_id" TEXT,
    "type" TEXT,
    "average_completion_time" TEXT,
    "transaction_explorer_template" TEXT,
    "account_explorer_template" TEXT,
    "listing_date" TIMESTAMP(3),

    CONSTRAINT "Network_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Currency" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "asset" TEXT NOT NULL,
    "logo" TEXT,
    "contract_address" TEXT,
    "decimals" INTEGER,
    "price_in_usd" DOUBLE PRECISION,
    "precision" INTEGER,
    "is_native" BOOLEAN,
    "listing_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "network_id" INTEGER NOT NULL,

    CONSTRAINT "Currency_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DepositAction" (
    "id" SERIAL NOT NULL,
    "type" TEXT DEFAULT 'transfer',
    "to_address" TEXT,
    "amount" DOUBLE PRECISION,
    "order_number" INTEGER,
    "amount_in_base_units" TEXT,
    "network_id" INTEGER NOT NULL,
    "currency_id" INTEGER NOT NULL,
    "fee_currency_id" INTEGER NOT NULL,
    "call_data" TEXT,
    "swap_id" TEXT NOT NULL,

    CONSTRAINT "DepositAction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Swap" (
    "id" TEXT NOT NULL,
    "created_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "source_network_id" INTEGER NOT NULL,
    "source_exchange" TEXT,
    "source_asset_id" INTEGER NOT NULL,
    "source_address" TEXT NOT NULL,
    "destination_network_id" INTEGER NOT NULL,
    "destination_exchange" TEXT,
    "destination_asset_id" INTEGER NOT NULL,
    "destination_address" TEXT NOT NULL,
    "refuel" BOOLEAN NOT NULL,
    "use_deposit_address" BOOLEAN NOT NULL,
    "requested_amount" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "fail_reason" TEXT,
    "metadata_sequence_number" INTEGER,
    "block_number" INTEGER NOT NULL,
    "deposit_address_id" INTEGER NOT NULL,

    CONSTRAINT "Swap_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transaction" (
    "id" SERIAL NOT NULL,
    "from" TEXT NOT NULL,
    "to" TEXT NOT NULL,
    "created_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "transaction_hash" TEXT NOT NULL,
    "confirmations" INTEGER NOT NULL,
    "max_confirmations" INTEGER NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "type" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "network_id" INTEGER,
    "currency_id" INTEGER,
    "swap_id" TEXT,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Quote" (
    "id" SERIAL NOT NULL,
    "swap_id" TEXT NOT NULL,
    "receive_amount" DOUBLE PRECISION NOT NULL,
    "min_receive_amount" DOUBLE PRECISION NOT NULL,
    "blockchain_fee" DOUBLE PRECISION NOT NULL,
    "service_fee" DOUBLE PRECISION NOT NULL,
    "avg_completion_time" TEXT NOT NULL,
    "slippage" DOUBLE PRECISION NOT NULL,
    "total_fee" DOUBLE PRECISION NOT NULL,
    "total_fee_in_usd" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "Quote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DepositAddress" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,
    "address" TEXT NOT NULL,

    CONSTRAINT "DepositAddress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RpcNode" (
    "id" SERIAL NOT NULL,
    "url" TEXT NOT NULL,
    "network_id" INTEGER NOT NULL,

    CONSTRAINT "RpcNode_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Network_internal_name_key" ON "Network"("internal_name");

-- CreateIndex
CREATE INDEX "Currency_network_id_idx" ON "Currency"("network_id");

-- CreateIndex
CREATE INDEX "Currency_asset_idx" ON "Currency"("asset");

-- CreateIndex
CREATE UNIQUE INDEX "DepositAction_swap_id_key" ON "DepositAction"("swap_id");

-- CreateIndex
CREATE INDEX "DepositAction_swap_id_idx" ON "DepositAction"("swap_id");

-- CreateIndex
CREATE INDEX "Swap_id_idx" ON "Swap"("id");

-- CreateIndex
CREATE INDEX "Transaction_swap_id_idx" ON "Transaction"("swap_id");

-- CreateIndex
CREATE INDEX "Transaction_status_idx" ON "Transaction"("status");

-- CreateIndex
CREATE INDEX "Transaction_transaction_hash_idx" ON "Transaction"("transaction_hash");

-- CreateIndex
CREATE INDEX "Transaction_currency_id_idx" ON "Transaction"("currency_id");

-- CreateIndex
CREATE INDEX "Transaction_network_id_idx" ON "Transaction"("network_id");

-- CreateIndex
CREATE UNIQUE INDEX "Quote_swap_id_key" ON "Quote"("swap_id");

-- CreateIndex
CREATE INDEX "DepositAddress_type_idx" ON "DepositAddress"("type");

-- CreateIndex
CREATE INDEX "DepositAddress_address_idx" ON "DepositAddress"("address");

-- AddForeignKey
ALTER TABLE "Currency" ADD CONSTRAINT "Currency_network_id_fkey" FOREIGN KEY ("network_id") REFERENCES "Network"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DepositAction" ADD CONSTRAINT "DepositAction_network_id_fkey" FOREIGN KEY ("network_id") REFERENCES "Network"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DepositAction" ADD CONSTRAINT "DepositAction_currency_id_fkey" FOREIGN KEY ("currency_id") REFERENCES "Currency"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DepositAction" ADD CONSTRAINT "DepositAction_fee_currency_id_fkey" FOREIGN KEY ("fee_currency_id") REFERENCES "Currency"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DepositAction" ADD CONSTRAINT "DepositAction_swap_id_fkey" FOREIGN KEY ("swap_id") REFERENCES "Swap"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Swap" ADD CONSTRAINT "Swap_source_network_id_fkey" FOREIGN KEY ("source_network_id") REFERENCES "Network"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Swap" ADD CONSTRAINT "Swap_source_asset_id_fkey" FOREIGN KEY ("source_asset_id") REFERENCES "Currency"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Swap" ADD CONSTRAINT "Swap_destination_network_id_fkey" FOREIGN KEY ("destination_network_id") REFERENCES "Network"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Swap" ADD CONSTRAINT "Swap_destination_asset_id_fkey" FOREIGN KEY ("destination_asset_id") REFERENCES "Currency"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Swap" ADD CONSTRAINT "Swap_deposit_address_id_fkey" FOREIGN KEY ("deposit_address_id") REFERENCES "DepositAddress"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_network_id_fkey" FOREIGN KEY ("network_id") REFERENCES "Network"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_currency_id_fkey" FOREIGN KEY ("currency_id") REFERENCES "Currency"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_swap_id_fkey" FOREIGN KEY ("swap_id") REFERENCES "Swap"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Quote" ADD CONSTRAINT "Quote_swap_id_fkey" FOREIGN KEY ("swap_id") REFERENCES "Swap"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RpcNode" ADD CONSTRAINT "RpcNode_network_id_fkey" FOREIGN KEY ("network_id") REFERENCES "Network"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
