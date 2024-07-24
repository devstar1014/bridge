-- CreateTable
CREATE TABLE "SwapUserInfo" (
    "_id" TEXT NOT NULL,
    "amount" DOUBLE PRECISION,
    "source_network" TEXT,
    "source_exchange" TEXT,
    "source_asset" TEXT,
    "source_address" TEXT,
    "destination_network" TEXT,
    "destination_exchange" TEXT,
    "destination_asset" TEXT,
    "destination_address" TEXT,
    "refuel" BOOLEAN NOT NULL DEFAULT false,
    "use_deposit_address" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SwapUserInfo_pkey" PRIMARY KEY ("_id")
);

-- CreateTable
CREATE TABLE "Network" (
    "id" SERIAL NOT NULL,
    "name" TEXT,
    "display_name" TEXT,
    "logo" TEXT,
    "chain_id" TEXT,
    "node_url" TEXT,
    "type" TEXT,
    "transaction_explorer_template" TEXT,
    "account_explorer_template" TEXT,
    "listing_date" TIMESTAMP(3),
    "token_id" INTEGER,
    "transaction_id" INTEGER,

    CONSTRAINT "Network_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Token" (
    "id" SERIAL NOT NULL,
    "symbol" TEXT NOT NULL,
    "logo" TEXT NOT NULL,
    "contract" TEXT,
    "decimals" INTEGER NOT NULL,
    "price_in_usd" DOUBLE PRECISION NOT NULL,
    "precision" INTEGER NOT NULL,
    "listing_date" TIMESTAMP(3),
    "transaction_id" INTEGER,

    CONSTRAINT "Token_pkey" PRIMARY KEY ("id")
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
    "token_id" INTEGER NOT NULL,
    "fee_token_id" INTEGER NOT NULL,
    "call_data" TEXT,
    "swap_id" TEXT NOT NULL,

    CONSTRAINT "DepositAction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Swap" (
    "id" TEXT NOT NULL,
    "created_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "source_network" TEXT NOT NULL,
    "source_exchange" TEXT,
    "source_asset" TEXT NOT NULL,
    "source_address" TEXT NOT NULL,
    "destination_network" TEXT NOT NULL,
    "destination_exchange" TEXT,
    "destination_asset" TEXT NOT NULL,
    "destination_address" TEXT NOT NULL,
    "refuel" BOOLEAN NOT NULL,
    "use_deposit_address" BOOLEAN NOT NULL,
    "is_deleted" BOOLEAN NOT NULL DEFAULT false,
    "requested_amount" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "fail_reason" TEXT,
    "metadata_sequence_number" INTEGER,

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
    "token_id" INTEGER,
    "network_id" INTEGER,
    "swap_id" TEXT,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ContractAddress" (
    "swap_id" TEXT,
    "id" SERIAL NOT NULL,
    "address" TEXT,
    "name" TEXT,

    CONSTRAINT "ContractAddress_pkey" PRIMARY KEY ("id")
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

-- CreateIndex
CREATE UNIQUE INDEX "SwapUserInfo__id_key" ON "SwapUserInfo"("_id");

-- CreateIndex
CREATE UNIQUE INDEX "Network_token_id_key" ON "Network"("token_id");

-- CreateIndex
CREATE UNIQUE INDEX "Network_transaction_id_key" ON "Network"("transaction_id");

-- CreateIndex
CREATE UNIQUE INDEX "Token_transaction_id_key" ON "Token"("transaction_id");

-- CreateIndex
CREATE UNIQUE INDEX "DepositAction_token_id_key" ON "DepositAction"("token_id");

-- CreateIndex
CREATE UNIQUE INDEX "DepositAction_fee_token_id_key" ON "DepositAction"("fee_token_id");

-- CreateIndex
CREATE UNIQUE INDEX "DepositAction_swap_id_key" ON "DepositAction"("swap_id");

-- CreateIndex
CREATE INDEX "DepositAction_swap_id_idx" ON "DepositAction"("swap_id");

-- CreateIndex
CREATE UNIQUE INDEX "ContractAddress_swap_id_key" ON "ContractAddress"("swap_id");

-- CreateIndex
CREATE UNIQUE INDEX "Quote_swap_id_key" ON "Quote"("swap_id");

-- AddForeignKey
ALTER TABLE "Network" ADD CONSTRAINT "Network_token_id_fkey" FOREIGN KEY ("token_id") REFERENCES "Token"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DepositAction" ADD CONSTRAINT "DepositAction_network_id_fkey" FOREIGN KEY ("network_id") REFERENCES "Network"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DepositAction" ADD CONSTRAINT "DepositAction_token_id_fkey" FOREIGN KEY ("token_id") REFERENCES "Token"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DepositAction" ADD CONSTRAINT "DepositAction_fee_token_id_fkey" FOREIGN KEY ("fee_token_id") REFERENCES "Token"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DepositAction" ADD CONSTRAINT "DepositAction_swap_id_fkey" FOREIGN KEY ("swap_id") REFERENCES "Swap"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_token_id_fkey" FOREIGN KEY ("token_id") REFERENCES "Token"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_network_id_fkey" FOREIGN KEY ("network_id") REFERENCES "Network"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_swap_id_fkey" FOREIGN KEY ("swap_id") REFERENCES "Swap"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ContractAddress" ADD CONSTRAINT "ContractAddress_swap_id_fkey" FOREIGN KEY ("swap_id") REFERENCES "Swap"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Quote" ADD CONSTRAINT "Quote_swap_id_fkey" FOREIGN KEY ("swap_id") REFERENCES "Swap"("id") ON DELETE RESTRICT ON UPDATE CASCADE;