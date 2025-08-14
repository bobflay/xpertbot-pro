<?php

namespace Database\Seeders;

use App\Models\Product;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    public function run()
    {
        $products = [
            [
                'name' => 'Laptop Pro',
                'description' => 'High-performance laptop for professionals',
                'price' => 1299.99,
                'stock' => 50,
                'category' => 'Electronics',
            ],
            [
                'name' => 'Wireless Mouse',
                'description' => 'Ergonomic wireless mouse with long battery life',
                'price' => 29.99,
                'stock' => 200,
                'category' => 'Accessories',
            ],
            [
                'name' => 'USB-C Hub',
                'description' => 'Multi-port USB-C hub for modern devices',
                'price' => 49.99,
                'stock' => 150,
                'category' => 'Accessories',
            ],
            [
                'name' => 'Mechanical Keyboard',
                'description' => 'RGB mechanical keyboard for gaming and productivity',
                'price' => 89.99,
                'stock' => 75,
                'category' => 'Accessories',
            ],
            [
                'name' => '4K Webcam',
                'description' => 'Professional 4K webcam for video conferencing',
                'price' => 149.99,
                'stock' => 30,
                'category' => 'Electronics',
            ],
        ];

        foreach ($products as $product) {
            Product::create($product);
        }
    }
}