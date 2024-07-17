import type { NextApiRequest, NextApiResponse } from 'next'
// import { mainnetSettings, testnetSettings } from '../../settings'

export default async function handler(
    req: NextApiRequest,
    res: NextApiResponse<{
        data: {
            wallet_fee_in_usd: number,
            wallet_fee: number,
            wallet_receive_amount: number,
            manual_fee_in_usd: number,
            manual_fee: number,
            manual_receive_amount: number,
            avg_completion_time: {
                total_minutes: number,
                total_seconds: number,
                total_hours: number
            },
            fee_usd_price: number
        }
    }>
) {
    const { amount, version, params } = req.query;
    const [source, source_asset, destination, destination_asset] = params as string[];

    console.log("rate", {
        amount,
        source,
        source_asset,
        destination,
        destination_asset
    });


    res.status(200).json({
        data: {
            wallet_fee_in_usd: 10,
            wallet_fee: 0.1,
            wallet_receive_amount: 0,
            manual_fee_in_usd: 0,
            manual_fee: 0,
            manual_receive_amount: 0,
            avg_completion_time: {
                total_minutes: 2,
                total_seconds: 0,
                total_hours: 0,
            },
            fee_usd_price: 10,
        }
    });
}