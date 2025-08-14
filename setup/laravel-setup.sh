#!/bin/bash
# setup/laravel-setup.sh

echo "🚀 Setting up Laravel API..."

# Detect if we're in Codespaces or local environment
if [ -d "/workspaces" ]; then
    # Codespace environment
    WORKSPACE_DIR="/workspaces/$(ls /workspaces | head -1)"
    cd "$WORKSPACE_DIR"
else
    # Local environment - use current directory or parent
    if [ -f "setup/laravel-setup.sh" ]; then
        # We're in the project root
        WORKSPACE_DIR="$(pwd)"
    else
        # We might be in a subdirectory
        cd ..
        WORKSPACE_DIR="$(pwd)"
    fi
fi

# Check if Laravel project already exists
if [ -d "laravel-api" ]; then
    echo "Laravel API directory already exists. Skipping creation."
    exit 0
fi

# Create Laravel project
composer create-project laravel/laravel laravel-api
cd laravel-api

# Install essential packages
echo "📦 Installing essential packages..."
composer require \
    laravel/sanctum \
    laravel/tinker \
    spatie/laravel-permission \
    spatie/laravel-query-builder

# Setup environment
cp .env.example .env
php artisan key:generate

# Configure SQLite database
sed -i 's/DB_CONNECTION=mysql/DB_CONNECTION=sqlite/' .env
sed -i "s|DB_DATABASE=laravel|DB_DATABASE=$WORKSPACE_DIR/laravel-api/database/database.sqlite|" .env
touch database/database.sqlite

# Setup Sanctum for API authentication
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# Run migrations
php artisan migrate

# Create sample models
echo "🏗️ Creating sample models..."
cat > app/Models/Product.php << 'EOF'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'price',
        'stock',
        'category',
        'image_url'
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'stock' => 'integer',
    ];
}
EOF

# Create migration for products
cat > database/migrations/$(date +%Y_%m_%d_%H%M%S)_create_products_table.php << 'EOF'
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->text('description')->nullable();
            $table->decimal('price', 10, 2);
            $table->integer('stock')->default(0);
            $table->string('category')->nullable();
            $table->string('image_url')->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('products');
    }
};
EOF

# Create API controller
cat > app/Http/Controllers/ProductController.php << 'EOF'
<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index()
    {
        return Product::all();
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric|min:0',
            'stock' => 'integer|min:0',
            'category' => 'nullable|string',
            'image_url' => 'nullable|url',
        ]);

        return Product::create($validated);
    }

    public function show(Product $product)
    {
        return $product;
    }

    public function update(Request $request, Product $product)
    {
        $validated = $request->validate([
            'name' => 'string|max:255',
            'description' => 'nullable|string',
            'price' => 'numeric|min:0',
            'stock' => 'integer|min:0',
            'category' => 'nullable|string',
            'image_url' => 'nullable|url',
        ]);

        $product->update($validated);
        return $product;
    }

    public function destroy(Product $product)
    {
        $product->delete();
        return response()->noContent();
    }
}
EOF

# Update API routes
cat >> routes/api.php << 'EOF'

use App\Http\Controllers\ProductController;

Route::apiResource('products', ProductController::class);
EOF

# Create database seeder
cat > database/seeders/ProductSeeder.php << 'EOF'
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
EOF

# Update DatabaseSeeder to include ProductSeeder
sed -i 's/\/\/ \\App\\Models\\User::factory/\\App\\Models\\User::factory/' database/seeders/DatabaseSeeder.php
echo "        \$this->call(ProductSeeder::class);" >> database/seeders/DatabaseSeeder.php

# Run migrations and seed
php artisan migrate:fresh --seed

# Configure CORS for API access
php artisan config:clear

# Create Nova installation instructions
cat > NOVA_SETUP.md << 'EOF'
# Laravel Nova Setup (Optional)

Laravel Nova is a paid admin panel for Laravel. If you have a Nova license, follow these steps:

## Installation

1. Add Nova repository to composer.json:
```json
"repositories": [
    {
        "type": "composer",
        "url": "https://nova.laravel.com"
    }
]
```

2. Add your Nova credentials:
```bash
composer config http-basic.nova.laravel.com your-nova-email@example.com your-license-key
```

3. Install Nova:
```bash
composer require laravel/nova
php artisan nova:install
php artisan migrate
```

4. Create an admin user:
```bash
php artisan nova:user
```

5. Access Nova at: http://localhost:8000/nova

## Creating Nova Resources

For each model, create a Nova resource:
```bash
php artisan nova:resource Product
```

This will create a resource file in `app/Nova/` that you can customize.
EOF

echo "✅ Laravel API setup complete!"
echo "📍 API available at: http://localhost:8000/api"
echo "📚 Sample endpoints:"
echo "   GET    /api/products"
echo "   POST   /api/products"
echo "   GET    /api/products/{id}"
echo "   PUT    /api/products/{id}"
echo "   DELETE /api/products/{id}"
echo ""
echo "💡 For Nova admin panel setup, see laravel-api/NOVA_SETUP.md"