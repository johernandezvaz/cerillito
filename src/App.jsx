import React, { useState, useEffect } from 'react';
import { ArrowPathIcon, CheckIcon, BookOpenIcon } from '@heroicons/react/24/outline';
import ItemsByCategoryList from './components/ItemsByCategoryList';
import BagList from './components/BagList';
import ValidatePackingModal from './components/ValidatePackingModal';
import PackingRulesModal from './components/PackingRulesModal';

function App() {
  const [items, setItems] = useState([]);
  const [bags, setBags] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [draggedItem, setDraggedItem] = useState(null);
  const [notification, setNotification] = useState(null);
  const [showValidationModal, setShowValidationModal] = useState(false);
  const [showRulesModal, setShowRulesModal] = useState(false);
  const [validationResult, setValidationResult] = useState(null);

  useEffect(() => {
    fetchItems();
  }, []);

  const fetchItems = async () => {
    try {
      setLoading(true);
      const response = await fetch('http://localhost:3000/api/items');
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const result = await response.json();
      
      if (!result.error) {
        setItems(result.items || []);
        setError(null);
      } else {
        setError('Error al cargar los artículos: ' + result.error);
      }
    } catch (err) {
      setError('Error de conexión con el servidor: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  const validatePacking = async () => {
    try {
      setLoading(true);
      const response = await fetch('http://localhost:3000/api/validate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ bags }),
      });
      
      const result = await response.json();
      
      if (!result.error) {
        setValidationResult(result);
        setShowValidationModal(true);
      } else {
        showNotification('Error al validar empaque: ' + result.error, 'error');
      }
    } catch (err) {
      showNotification('Error de conexión con el servidor: ' + err.message, 'error');
    } finally {
      setLoading(false);
    }
  };

  const addItemToBag = (itemId, bagId) => {
    const item = items.find(i => i.id === itemId);
    const bag = bags.find(b => b.id === bagId);
    
    if (!item || !bag) return;

    // Check weight limit
    const newWeight = bag.totalWeight + item.weight;
    if (newWeight > 5.0) {
      showNotification('La bolsa excedería el límite de peso', 'error');
      return;
    }

    // Check compatibility with existing items
    const hasIncompatibleItems = checkIncompatibilities(item, bag.items);
    if (hasIncompatibleItems) {
      showNotification('Artículos incompatibles no pueden ir en la misma bolsa', 'error');
      return;
    }

    const updatedBags = bags.map(b => {
      if (b.id === bagId) {
        return {
          ...b,
          items: [...b.items, item],
          totalWeight: newWeight
        };
      }
      return b;
    });

    setBags(updatedBags);
    showNotification('¡Artículo empacado correctamente!', 'success');
  };

  // Helper function to check incompatibilities based on packing_rules.m
  const checkIncompatibilities = (item, bagItems) => {
    const itemCategory = getCategoryType(item.category);
    
    // Check for incompatible items in the bag
    return bagItems.some(bagItem => {
      const bagItemCategory = getCategoryType(bagItem.category);
      
      // Food and chemicals should not be mixed
      if (isFood(itemCategory) && bagItemCategory === 'chemicals') {
        return true;
      }
      if (itemCategory === 'chemicals' && isFood(bagItemCategory)) {
        return true;
      }
      
      // Food and cleaning supplies should not be mixed
      if (isFood(itemCategory) && bagItemCategory === 'cleaning') {
        return true;
      }
      if (itemCategory === 'cleaning' && isFood(bagItemCategory)) {
        return true;
      }
      
      // Heavy and fragile items should not be mixed
      if (itemCategory === 'heavy' && bagItemCategory === 'fragile') {
        return true;
      }
      if (itemCategory === 'fragile' && bagItemCategory === 'heavy') {
        return true;
      }
      
      return false;
    });
  };

  // Helper to map UI category names to internal category types
  const getCategoryType = (categoryName) => {
    const categoryMap = {
      'Frutas y Verduras': 'produce',
      'Lácteos': 'dairy',
      'Carnes': 'meat',
      'Panadería': 'bakery',
      'Frágil': 'fragile',
      'Congelados': 'frozen',
      'Químicos': 'chemicals',
      'Limpieza': 'cleaning',
      'Pesado': 'heavy',
      'Misceláneos': 'misc'
    };
    
    return categoryMap[categoryName] || 'misc';
  };

  // Helper to check if a category is food
  const isFood = (category) => {
    return ['produce', 'dairy', 'meat', 'bakery', 'frozen'].includes(category);
  };

  const removeItemFromBag = (bagId, itemIndex) => {
    const updatedBags = bags.map(bag => {
      if (bag.id === bagId) {
        const newItems = [...bag.items];
        const removedItem = newItems.splice(itemIndex, 1)[0];
        return {
          ...bag,
          items: newItems,
          totalWeight: bag.totalWeight - removedItem.weight
        };
      }
      return bag;
    });
    
    setBags(updatedBags);
    showNotification('Artículo removido de la bolsa', 'success');
  };

  const addNewBag = () => {
    const newBag = {
      id: bags.length + 1,
      items: [],
      totalWeight: 0
    };
    setBags([...bags, newBag]);
    showNotification('¡Nueva bolsa creada!', 'success');
  };

  const showNotification = (message, type) => {
    setNotification({ message, type });
    setTimeout(() => setNotification(null), 3000);
  };

  if (loading && items.length === 0) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <ArrowPathIcon className="h-8 w-8 animate-spin text-blue-500" />
      </div>
    );
  }

  if (error && items.length === 0) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">
          {error}
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 py-6">
      {notification && (
        <div className={`fixed top-4 right-4 px-4 py-2 rounded-lg shadow-lg transition-all transform ${
          notification.type === 'success' ? 'bg-green-500' : 'bg-red-500'
        } text-white z-50`}>
          {notification.message}
        </div>
      )}

      {loading && (
        <div className="fixed top-4 left-4">
          <ArrowPathIcon className="h-6 w-6 animate-spin text-blue-500" />
        </div>
      )}

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <header className="mb-6 flex justify-between items-center">
          <h1 className="text-3xl font-bold text-gray-800">Sistema de Empacado</h1>
          <div className="flex space-x-4">
            <button
              onClick={() => setShowRulesModal(true)}
              className="flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              <BookOpenIcon className="h-5 w-5 mr-2" />
              Ver Reglas
            </button>
            <button
              onClick={validatePacking}
              className="flex items-center px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors"
              disabled={bags.length === 0}
            >
              <CheckIcon className="h-5 w-5 mr-2" />
              Validar Empaque
            </button>
          </div>
        </header>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 h-[calc(100vh-12rem)]">
          <div className="overflow-y-auto pr-4">
            <ItemsByCategoryList 
              items={items} 
              setDraggedItem={setDraggedItem} 
            />
          </div>
          
          <div className="overflow-y-auto pr-4">
            <BagList 
              bags={bags}
              addNewBag={addNewBag}
              draggedItem={draggedItem}
              addItemToBag={addItemToBag}
              removeItemFromBag={removeItemFromBag}
            />
          </div>
        </div>
      </div>

      {showValidationModal && validationResult && (
        <ValidatePackingModal 
          validationResult={validationResult} 
          onClose={() => setShowValidationModal(false)} 
        />
      )}

      {showRulesModal && (
        <PackingRulesModal 
          onClose={() => setShowRulesModal(false)} 
        />
      )}
    </div>
  );
}

export default App;